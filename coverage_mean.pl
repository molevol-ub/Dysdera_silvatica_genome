#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use FindBin;
use lib $FindBin::Bin."/lib2";
require myModules;
use lib $FindBin::Bin."/lib";
require Parallel::ForkManager;

my $coverage=$ARGV[0]; 
my $file=$ARGV[1];
my $length = $ARGV[2];
my $plot=$ARGV[3];
my $CPU=$ARGV[4];

if (!@ARGV) {
	print "Given a mean coverage determines regions with greater spected coverage:
	- Coverage: 2.5x standard deviation
	- Length: Minimun length of reference to use
	\nUsage:\nperl $0 coverage file length output_plot CPU\n";
	exit();
}

my $max_coverage = $coverage*2.5;
## to get mean do: awk '{ sum +=$3; n++ } END { if (n > 0) print sum / n; }' Pacbio_CSS_PE.sorted.coverage.txt
## Result: 36.7009 mean coverage Pacbio vs. Paired-end ##

my $ref_array_count = myModules::get_size($file);
print "Stats for file: $file\n";
print "Chars: $ref_array_count\n";
my $block = int($ref_array_count/$CPU);
my $files_ref = myModules::file_splitter($file,$block,"txt");

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
my $concat_ids = "ids_concat.txt";
print "+ Concatenate ids into $concat_ids\n";
system("cat temp_* | sort | uniq > $concat_ids; rm temp_*");
my $total_ids = myModules::get_number_lines($concat_ids);
open (IDS, $concat_ids);
open (PLOT, ">$plot");

my $pm_SPLIT_ids =  new Parallel::ForkManager($CPU);
my $count = 0;
while (<IDS>) {
	$count++;
	my $pid = $pm_SPLIT_ids->start($count) and next;
	chomp;
	my $id=$_;
	print "\tChecking: $count / $total_ids\r";
	my $file_out = "temp_".$count;
	my $out = "temp_".$count.".out";
	system("grep -w $id $file > $file_out");
	my $length_seq = myModules::get_number_lines($file_out);

	if ($length_seq >= $length) {
		open (FILE, "$file_out");
		open (OUT, ">$out");
		while (<FILE>) {
			chomp;
			my @line = split("\t", $_);
			if ($line[2] >= $max_coverage) {
				print OUT $_."\n";
			} 
		}
		close(FILE); close (OUT);
		
		my $previous_position=0; my $initial_entry = 0; my $init=0; my %repeat; my $count = 1;
		open (F, "$out");
		while (<F>){
			chomp;
			my @line = split("\t", $_);
			
			unless ($initial_entry == 0) {
				my $initialize=0;
				if ($previous_position + 1 == $line[1]) { 		$initialize=0;
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
					$count++;
					$init=0;
			}}
			
			if ($init==0) {
				$init++; 
				if ($count > 1) {
					my $before = $count -1;
					$repeat{"repeat_".$count}{"INTER_start"} = $repeat{"repeat_".$before}{"intra_end"} + 1;
					$repeat{"repeat_".$count}{"INTER_end"} = $line[1]-1;
					$repeat{"repeat_".$count}{"intra_start"} = $line[1];
				} else {
					$repeat{"repeat_".$count}{"INTER_start"}=0;
					$repeat{"repeat_".$count}{"INTER_end"}=$line[1]-1;
					$repeat{"repeat_".$count}{"intra_start"}=$line[1];
					$initial_entry++;
				}
			} else {
				$repeat{"repeat_".$count}{"intra_end"}=$line[1];
			}
			$previous_position = $line[1];
		}
		close(F); system("rm $out");

		my $total_repeats = scalar keys %repeat;
		foreach my $keys (sort keys %repeat) {
			my $INTER_gap = int($repeat{$keys}{"INTER_end"} - $repeat{$keys}{"INTER_start"});
			my $intra_gap = int($repeat{$keys}{"intra_end"} - $repeat{$keys}{"intra_start"});
			print PLOT $id."\t".$length_seq."\t".$total_repeats."\t".$keys."\t".$repeat{$keys}{"INTER_start"}."\t".$repeat{$keys}{"INTER_end"}."\t".$INTER_gap."\t".$repeat{$keys}{"intra_start"}."\t".$repeat{$keys}{"intra_end"}."\t".$intra_gap."\n";
		}
		#print Dumper \%repeat;
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





