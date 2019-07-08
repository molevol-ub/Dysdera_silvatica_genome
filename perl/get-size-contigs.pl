#!/usr/bin/perl
use strict;
use warnings;

## get contigs longer than 5kb
my $file = $ARGV[0];

if (!$file) {
	print "No inputs provided\nPlease provide a contig file in fasta format\n";
	print "perl $0 contig_file.fasta\n";
	print "This script retrieves sequences sizes\n";
	exit();
}

open(FILE, $file) || die "Could not open the $file ...\n";
$/ = ">"; ## Telling perl where a new line starts
while (<FILE>) {		
	next if /^#/ || /^\s*$/;
	chomp;
	my ($titleline, $sequence) = split("\n",$_,2);
	next unless ($sequence && $titleline);
	$sequence =~ s/\n//g;
	my $len_seq = length($sequence);
	print $titleline."\t".$len_seq."\n";
}
close(FILE);
$/ = "\n";
