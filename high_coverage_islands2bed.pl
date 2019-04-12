#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $HCI_file=$ARGV[0]; ## must include 0 coverage values
my $name=$ARGV[1];
if (!@ARGV) {
	print "\nUsage:\nperl $0 HCI_file name\n\n";
	&print_definition();
	exit();
}
print "+ Parsing results...\n";
open (OUT, ">$name");
open(FILE, "<$HCI_file");
while (<FILE>) {
	chomp;
	my @array = split("\t", $_);	
	print OUT $array[0]."\t".$array[8]."\t".$array[9]."\t".$array[4]."\t1"."\t.\n";	
}
close(FILE); close(OUT);

sub print_definition {

print "
#####
## Definition:
Symbol * = high island coverage position
Symbol - = normal position

Example:
#--------****************-----------------****************-------------------
#	    1|2 intra      3|4   inter	5|6   intra      7|8

1: Nothing
2: Init intra-repeat
3: End intra-repeat
intra-repeat1_length = 3 - 2

4: Init inter-repeat
5: End inter-repeat
inter-repeat_length = 5 - 4

6: Init intra-repeat2
7: End intra-repeat2
intra-repeat2_length = 7 - 6

8: Nothing
"
}