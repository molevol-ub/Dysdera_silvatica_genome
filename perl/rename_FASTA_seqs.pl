#!/usr/bin/perl
use strict;
use warnings;

my $fasta = $ARGV[0];

if (scalar @ARGV != 1) {
	print "\n########\n";
	print "Usage:\n########\n\n";
	print "Please provide the Genbank file for Dysdera silvativa:\n";
	print "perl ".$0." fasta_file\n";
	exit();
} 
open(FILE, $fasta) || die "Could not open the $fasta ...\n";
$/ = ">"; ## Telling perl where a new line starts
while (<FILE>) {		
	next if /^#/ || /^\s*$/;
	chomp;
	my ($titleline, $sequence) = split(/\n/,$_,2);
	next unless ($sequence && $titleline);
    	$sequence =~ s/\n//g;
	my @array = split(",", $titleline);
	my @array2 = split(" ", $array[0]);
	print ">".$array2[-1]." Dysdera silvatica isolate NMH25907 ".$array2[0].", whole genome shotgun sequence\n$sequence\n";
}
close (FILE);
