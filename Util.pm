package Util;

use strict;
use warnings;

sub format_results {
	my $prefix = pop;
	my @results = @_;
	my @output = ();
	my $title;
	my $url;
	if (scalar(@results) <= 0) {
		return "Nothing found.";
	}
	for (my $idx = 0; $idx < scalar(@results); $idx += 1) {
		$title = $results[$idx]->{title};
		$url = produce_url($results[$idx]->{path}, $prefix);
		push(@output, "[$idx] $title: $url");
	}
	return join(' :: ', @output);
}

sub produce_url {
	my $url = shift;
	my $prefix = shift;
	return defined($prefix) ? "$prefix/$url" : $url;
}

sub format_term {
	my $term = shift;
	$term =~ s/[^0-9a-z ]//gi;
	return $term;
}

sub trim_whitespaces {
	my $content = shift;
	$content =~ s/^\s+|\r|\n|\s+$//g;
	return $content;
}

1;
