#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use FindBin;
use lib $FindBin::Bin."/lib";
require myModules;
require Parallel::ForkManager;

my $coverage=$ARGV[0]; ## must include 0 coverage values
my $file=$ARGV[1];
my $length = $ARGV[2];
my $plot=$ARGV[3];
my $CPU=$ARGV[4];
my $intra_gap_var = $ARGV[5];
my $ids_file=$ARGV[6];

if (!@ARGV) {
	print "\n\nGiven a mean coverage determines regions with greater spected coverage:
	- Coverage: 5x standard deviation
	- Length: Minimun length of reference to use
	\n\nUsage:\nperl $0 coverage file length output_file CPU intra_gap_cutoff [ids_file]\n\n";
	
	&print_definition();
	exit();
}

my $max_coverage = $coverage*5;
## to get mean do: awk '{ sum +=$3; n++ } END { if (n > 0) print sum / n; }' Pacbio_CSS_PE.sorted.coverage.txt
## Result: 36.7009 mean coverage Pacbio vs. Paired-end ##

## parse ids
my $concat_ids;
my $file2;

## intra_gap_cutoff
my @intra_gap_cutoff = split(",", $intra_gap_var);

if ($ids_file) {
	$concat_ids = $ids_file;
	
	## pregrep all ids into a temp file
	$file2 = $concat_ids.".tmp";
	system("grep -w -f $ids_file $file > $file2");
	
} else {
	## splits into subsets to determine the ids
	my $ref_array_count = myModules::get_size($file);
	print "Stats for file: $file\n";
	print "Chars: $ref_array_count\n";
	my $block = int($ref_array_count/$CPU);
	my $files_ref = myModules::file_splitter($file,$block,"txt");
	
	## Check subsets to determine the ids
	my @files = @{$files_ref};
	my $count_fasta_files_split = 0;
	my $total_fasta_files_split = scalar @files;
	my $pm_SPLIT_FILE =  new Parallel::ForkManager($CPU); 
	for (my $i=0; $i < scalar @files; $i++) {
		$count_fasta_files_split++;
		print "\n+ Checking file: [$count_fasta_files_split/$total_fasta_files_split]\n";
		my $pid = $pm_SPLIT_FILE->start($i) and next;
		my $subset = $files[$i];
		my $temp_file = "temp_$i";
		system("awk '{print \$1}' $subset | sort | uniq > $temp_file; rm $subset");
		$pm_SPLIT_FILE->finish($i); # pass an exit code to finish
	}
	$pm_SPLIT_FILE->wait_all_children; 
	
	## merge results
	$concat_ids = "ids_concat.txt";
	print "+ Concatenate ids into $concat_ids\n";
	system("cat temp_* | sort | uniq > $concat_ids; rm temp_*");
	$file2 = $file;
}

#
my $total_ids = myModules::get_number_lines($concat_ids);
open (IDS, $concat_ids);
open (PLOT, ">$plot");

## start checking each sequence
my $pm_SPLIT_ids =  new Parallel::ForkManager($CPU);
while (<IDS>) {
	
	my $id=$_;
	my @name_id = split("sequence_", $id);
	my $count = $name_id[1];
	
	## send thread
	my $pid = $pm_SPLIT_ids->start($count) and next;
	chomp;

	#print "\tChecking: $count / $total_ids\r";
	my $file_out = "temp_".$count;
	my $out = "temp_".$count.".out";
	system("grep -w $id $file2 > $file_out");
	
	## retrieve coverage for each sample
	my $length_seq = myModules::get_number_lines($file_out);
	if ($length_seq >= $length) { ## filter by given length
		open (FILE, "$file_out");
		open (OUT, ">$out");
		while (<FILE>) {
			chomp;
			my @line = split("\t", $_);
			if ($line[2] >= $max_coverage) { 
				print OUT $_."\n";
		}}
		close(FILE); close (OUT);
		if (-r -s -e $out) { ## continue
		} else { ## file is empty
			system("rm $out"); 
			system ("rm $file_out");
	        $pm_SPLIT_ids->finish($count); # pass an exit code to finish
		}
		my $previous_position=0; my $initial_entry = 0; my $init=0; my %repeat; my $countID = 1;
		open (F, "$out");
		while (<F>){
			#print $_;	
			chomp;
			my @line = split("\t", $_);
			unless ($initial_entry == 0) {
				my $initialize=0;
				if ($previous_position + 1 == $line[1]) {
					$initialize=0;
				} elsif ($previous_position + 2 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 3 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 4 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 5 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 6 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 7 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 8 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 9 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 10 == $line[1]) {	$initialize=0;
				} elsif ($previous_position + 11 == $line[1]) {	$initialize=0;
				
				} else {
					$initialize=1;
				}					
				if ($initialize) {
					$countID++;
					$init=0;
				}			
			}			
			if ($init==0) {
				$init++;				
				if ($countID > 1) {
					my $before = $countID -1;
					if (!$repeat{"repeat_".$before}{"intra_end"}) { 
						$before = $before - 1; $countID = $countID - 1;
					}
					if (!$repeat{"repeat_".$before}{"intra_end"}) {
						$repeat{"repeat_".$countID}{"INTER_start"} = 0;							
					} else {
						$repeat{"repeat_".$countID}{"INTER_start"} = $repeat{"repeat_".$before}{"intra_end"} + 1;
					}
					$repeat{"repeat_".$countID}{"INTER_end"} = $line[1]-1;
					$repeat{"repeat_".$countID}{"intra_start"} = $line[1];
					$repeat{"repeat_".$countID}{"intra_end"} = $line[1];
				} else {
					$repeat{"repeat_".$countID}{"INTER_start"}=0;
					$repeat{"repeat_".$countID}{"INTER_end"}=$line[1]-1;
					$repeat{"repeat_".$countID}{"intra_start"}=$line[1];
					$initial_entry++;
				}
			
			} else {
				$repeat{"repeat_".$countID}{"intra_end"}=$line[1];
			}
		
			$previous_position = $line[1];
		}
		close(F); close (OUT);
		system("rm $out");
		#print Dumper \%repeat;
		
		## for loop variable min intra gap
		for (my $i=0; $i < scalar @intra_gap_cutoff; $i++) {
		
			### discard bad repeats
			my %new_repeat;
			my $total_repeats_tmp = scalar keys %repeat;
			my $new_id = 0;
		
			for (my $k=0; $k < scalar $total_repeats_tmp; $k++) {
				my $keys = "repeat_".$k;
				#print $keys."\n";
				if (!$repeat{$keys}{"intra_end"}) {next;}
				my $intra_gap = int($repeat{$keys}{"intra_end"} - $repeat{$keys}{"intra_start"});
			
				if ($intra_gap < $intra_gap_cutoff[$i]) { ## set value user input and loop for results
					my $next_it; my $next_keys;
					$next_it = $k + 1;	
					$next_keys = "repeat_".$next_it;
					$repeat{$next_keys}{"INTER_start"} = $repeat{$keys}{"INTER_start"};
					#print "Next ($next_it = $next_keys): ".$repeat{$next_keys}{"INTER_start"}."\n";
					next; 
			
				} else {
					$new_id++;
					my $new_key = "repeat_".$new_id;
					#$new_repeat{$keys} = $repeat{$keys};
					$new_repeat{$new_key} = $repeat{$keys}
			
				}
			}
			#print Dumper \%new_repeat;
			## print repeats
			my $total_repeats = scalar keys %new_repeat;
			if ($total_repeats > 1) {
				my $counter = 0;
				foreach my $keys (sort keys %new_repeat) {
					if (!$new_repeat{$keys}{"intra_end"} || $keys eq "repeat_1") {
						my $intra_gap = int($new_repeat{$keys}{"intra_end"} - $new_repeat{$keys}{"intra_start"});
						print PLOT $id."\t".$intra_gap_cutoff[$i]."\t".$length_seq."\t".$total_repeats."\t".$keys."\t-\t-\t-\t".$new_repeat{$keys}{"intra_start"}."\t".$new_repeat{$keys}{"intra_end"}."\t".$intra_gap."\n";
						## 		    ids		length_contig	total_repeats		id_repeat			inter_start						inter_end					gap_inter					intra_start						intra_end					intra_gap
					} else {
						my $INTER_gap = int($new_repeat{$keys}{"INTER_end"} - $new_repeat{$keys}{"INTER_start"});
						my $intra_gap = int($new_repeat{$keys}{"intra_end"} - $new_repeat{$keys}{"intra_start"});
						print PLOT $id."\t".$intra_gap_cutoff[$i]."\t".$length_seq."\t".$total_repeats."\t".$keys."\t".$new_repeat{$keys}{"INTER_start"}."\t".$new_repeat{$keys}{"INTER_end"}."\t".$INTER_gap."\t".$new_repeat{$keys}{"intra_start"}."\t".$new_repeat{$keys}{"intra_end"}."\t".$intra_gap."\n";
						## 		    ids		length_contig	total_repeats		id_repeat			inter_start						inter_end					gap_inter					intra_start						intra_end					intra_gap
			}}} else {
				# 1
				foreach my $keys (sort keys %new_repeat) {
					if (!$new_repeat{$keys}{"intra_end"}) {next;}
					my $intra_gap = int($new_repeat{$keys}{"intra_end"} - $new_repeat{$keys}{"intra_start"});
					print PLOT $id."\t".$intra_gap_cutoff[$i]."\t".$length_seq."\t".$total_repeats."\t".$keys."\t-\t-\t-\t".$new_repeat{$keys}{"intra_start"}."\t".$new_repeat{$keys}{"intra_end"}."\t".$intra_gap."\n";
					## 		    ids		length_contig	total_repeats		id_repeat			inter_start						inter_end					gap_inter					intra_start						intra_end					intra_gap
			}} 
			#print Dumper \%repeat;
		}	
	} else {
		#print "$id is shorter than expected\n";
	} 
	system("rm $file_out");
	$pm_SPLIT_ids->finish($count); # pass an exit code to finish
}
$pm_SPLIT_ids->wait_all_children; 
close (IDS); close (PLOT);
system("rm $concat_ids");
print "\nFinish checking coverage of repeats...\n";

#system("cat $plot");



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
