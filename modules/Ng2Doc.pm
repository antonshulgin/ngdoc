package Ng2Doc;

use strict;
use warnings;

use LWP::Simple;

use Util;

use constant TAG => 'Ng2Doc';
use constant HOST_URL => 'https://angular.io/docs/ts/latest/api';
use constant INDEX_URL => HOST_URL . '/api-list.json';

sub lookup {
	my $term = shift;
	$term = Util::format_term($term);
	if (!defined($term)) {
		return;
	};
	if (length($term) < 3) {
		return produce_tagged_message('Give me more letters');
	}
	print("Ng2Doc: looking up '$term'...\n");
	my $content = LWP::Simple::get(INDEX_URL);
	if (!defined($content)) {
		return produce_tagged_message('Returned empty request, try again later');
	}
	my @entries = extract_entries(Util::trim_whitespaces($content));
	my @results = extract_results($term, @entries);
	return produce_tagged_message(Util::format_results(@results, HOST_URL));
}

sub produce_tagged_message {
	my $message = shift;
	return TAG . ": $message\n";
}

sub extract_results {
	my $term = shift;
	my @entries = @_;
	my @results = ();
	for my $entry (@entries) {
		if ($entry->{title} =~ /${term}/i) {
			push(@results, $entry);
		}
	}
	return @results;
}

sub extract_entries {
	my $content = shift;
	my @entries = ($content =~ /\{\s*([^\}]+)\s*\}/g);
	return parse_entries(@entries);
}

sub parse_entries {
	my @entries = @_;
	my @parsed_entries = ();
	for my $entry (@entries) {
		push(@parsed_entries, parse_entry($entry));
	}
	return @parsed_entries;
}

sub parse_entry {
	my $raw_entry = shift;
	my %entry = (
		title => ($raw_entry =~ /"title"\:\s*"([^"]+)"/i),
		path => ($raw_entry =~ /"path"\:\s*"([^"]+)"/i),
	);
	return \%entry;
}

1;
