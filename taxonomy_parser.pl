#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $file2=$ARGV[0]; #file to search

my %taxonomy;
while (<DATA>) {
	chomp;
	my @array = split("\t",$_);
	my @array2 = split(",",$array[1]);
	for (my $i=0; $i<scalar @array2;$i++) {
		push( @{ $taxonomy{$array[0]} }, $array2[$i]);
	}
}
close(DATA);
print Dumper \%taxonomy;

##
open (F, $file2);
while (<F>) {
	chomp;
	my @array = split("\t",$_);
	my @array2 = split(",",$array[2]);
	my @available_taxa = keys %taxonomy;
	#print $_."\n"; print"###################################\n"; print "Available:\n";	print Dumper \@available_taxa;	
	my %temp;
	for (my $i=0; $i<scalar @array2;$i++) {
		my $taxa = $array2[$i];
		#print $taxa."\n";
		for (my $k=0; $k < scalar @available_taxa; $k++) {
			if (grep /$taxa/, @{ $taxonomy{ $available_taxa[$k] } } ) { 
				#print "OK:$available_taxa[$k]\n";
				$temp{$available_taxa[$k]}++; 
			} else {
				delete $temp{$available_taxa[$k]};
				#print "\tMissing:$available_taxa[$k]\n";
			}		
		}
		@available_taxa = keys %temp; 
		#print "_______________________________\n"; print "Available:\n"; print Dumper \@available_taxa;
	}
	#print Dumper sort {$a cmp $b} \@available_taxa;
	my $max=0;
	my %max_id;
	for (my $j=0; $j < scalar @available_taxa; $j++) {
		my @name = split("_", $available_taxa[$j]);
		if ($max < $name[0]) {
			$max = $name[0];
			$max_id{"max"} = $name[1];
		}
	}
	print $_."\t".$max_id{"max"}."\n";
}
close (F);


__DATA__
17_Haplogynae	LREC
15_araneomorphae	Smimosarum,LHES,LREC,PTEP	
13_araneae	Agen,LHES,LREC,Smimosarum,PTEP
10_arachnida	Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
8_chelicerata	LPOL,Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
3_arthropoda	Dmel,Bmori,Phumanus,Dpul,Smartitima,Hdujardini,LPOL,Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
1_ecdysozooa	Celegans,Dmel,Bmori,Phumanus,Dpul,Smartitima,Hdujardini,LPOL,Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
