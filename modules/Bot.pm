package Bot;

use strict;
use warnings;

use IO::Socket;
use modules::NgDoc;
use modules::Ng2Doc;

sub run {
	my $server = shift;
	my $port = shift;
	my $nickname = shift;
	my @channels = @_;
	my $socket = IO::Socket::INET->new(
		PeerAddr => $server,
		PeerPort => $port,
		Proto => 'tcp',
	);
	if ($socket) {
		authenticate($socket, $nickname, $server);
		join_channels($socket, @channels);
		dispatch($socket, $nickname);
	}
}

sub dispatch {
	my $socket = shift;
	my $nickname = shift;
	my $sender;
	my $message;
	my $ng_version;
	my $term;
	my $response;
	while (my $message = <$socket>) {

		if ($message =~ /^PING\s+\:([\w.]+)/) {
			print $socket "PONG $1\n";
			print "Ping? Pong.\n";
		}

		if ($message =~ /^\S+\s+PRIVMSG\s+(\S+)\s+\:${nickname}[\W]*\s*(.+)$/) {
			$sender = $1;
			$message = $2;
			$message =~ s/^\s*|\s*$//;
			print "*** message from $sender: $message\n";
			if ($message =~ /^(\d?)\s*(.+)$/) {
				$ng_version = $1;
				$term = $2;
				$response = ($ng_version == 2) ? Ng2Doc::lookup($term) : NgDoc::lookup($term);
				if (defined($response)) {
					print $socket "PRIVMSG $sender :$response\n";
				}
			} else {
				print $socket "PRIVMSG $sender :Usage: [angular version number] <search term>\n";
			}
		}

	}
}

sub parse_channels {
	my $channels = shift;
	$channels =~ s/\s//g;
	return split(',', $channels);
}

sub join_channels {
	my $socket = shift;
	my @channels = @_;
	for my $channel (@channels) {
		print "Joining $channel\n";
		print $socket "JOIN :$channel\n";
	}
}

sub authenticate {
	my $socket = shift;
	my $nickname = shift;
	my $server = shift;
	print $socket "USER $nickname internets $server :derp\n";
	print $socket "NICK $nickname\n";
}

1;
