#!/usr/bin/perl

use strict;
use warnings;

use modules::Bot;

init(@ARGV);

sub init {
	if (scalar(@_) < 4) {
		die("Usage: $0 <server> <port> <nickname> \"<#channel1,#channel2,#etc>\"\n");
	}
	my $server = shift;
	my $port = shift;
	my $nickname = shift;
	my @channels = Bot::parse_channels(shift);
	Bot::run($server, $port, $nickname, @channels);
}
