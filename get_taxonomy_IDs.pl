#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $file =$ARGV[0];
my %detail_id;
my %id;
my $old_id;
open (F, $file);
while (<F>) {
	chomp;
	my @array = split ("\t", $_);
	if ($array[10] > 1e-03) { next;}

	my $new_id = $array[0];
        if (!$old_id) { $old_id = $array[0]; }
	#print $array[0]."\n";

	if ($old_id eq $new_id) {
	        push ( @{ $detail_id{$array[0]} }, $array[1]);
	        my @split = split("_",$array[1]);
		push ( @{ $id{$array[0]} }, $split[0]);

	} else {
		#print Dumper $id{$old_id}."\n"; 
		my @detail_ids = sort @{ $detail_id{$old_id} };
		my @uniq = do { my %seen; grep { !$seen{$_}++ } @detail_ids };

                my @ids = sort @{ $id{$old_id} };
                my @uniq_id = do { my %seen; grep { !$seen{$_}++ } @ids };

		print $old_id."\t".join(",",@uniq)."\t".join(",",@uniq_id)."\n";

		delete $id{$old_id};
		$old_id = $array[0];

		push ( @{ $detail_id{$array[0]} }, $array[1]);
                my @split = split("_",$array[1]);
                push ( @{ $id{$array[0]} }, $split[0]);
	}
}
close (F);


## README: get taxonomy summary using taxonomy_parser.pl
