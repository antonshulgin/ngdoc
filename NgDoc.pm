package NgDoc;

use strict;
use warnings;

use LWP::Simple;
use Exporter;

use constant HOST_URL => 'https://docs.angularjs.org';
use constant INDEX_URL => HOST_URL . '/js/search-data.json';

BEGIN {
	require Exporter;
	our @EXPORT = qw(lookup);
}

sub lookup {
	my $search_term = shift;
	$search_term = format_search_term($search_term);
	if (!defined $search_term) {
		return;
	};
	if (length($search_term) < 3) {
		return 'Give me more letters';
	}
	print("looking up '$search_term'...\n");
	my $content = get(INDEX_URL);
	if (!defined $content) {
		return 'Returned empty request, try again later';
	}
	my @entries = get_entries(trim_whitespaces($content));
	my @results = get_results($search_term, @entries);
	return format_results(@results);
}

sub format_search_term {
	my $search_term = shift;
	$search_term =~ s/[^a-z.]//gi;
	return $search_term;
}

sub format_results {
	my @results = @_;
	my @output = ();
	my $title;
	my $url;
	if (scalar(@results) <= 0) {
		return "Nothing found.";
	}
	for (my $idx = 0; $idx < scalar(@results); $idx += 1) {
		$title = $results[$idx]->{title};
		$url = produce_url($results[$idx]->{path});
		push(@output, "[$idx] $title: $url");
	}
	return join(' :: ', @output);
}

sub produce_url {
	my $path = shift;
	return HOST_URL . "/$path";
}

sub get_results {
	my $search_term = shift;
	my @entries = @_;
	my @results = ();
	for my $entry (@entries) {
		if ($entry->{title} =~ /${search_term}/i) {
			push(@results, $entry);
		}
	}
	return @results;
}

sub get_entries {
	my $content = shift;
	my @entries = ($content =~ m/\{\s*([^\}]+)\s*\}/g);
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
		title => ($raw_entry =~ /"titleWords"\:\s*"([^"]+)"/i),
		path => ($raw_entry =~ /"path"\:\s*"([^"]+)"/i),
	);
	return \%entry;
}

sub trim_whitespaces {
	my $string = shift;
	$string =~ s/^\s+|\r|\n|\s+$//g;
	return $string;
}

1;
