#!/usr/bin/perl
package myModules;
sub waiting {

	my $id_ref = $_[0];
	for (my $j=0; $j < scalar @$id_ref; $j++) {
		my $id = $$id_ref[$j];
		my $file = "info_".$id.".txt";
		while (1) {
			my $out = system("qstat -j $id > $file");	
			my $finish;
			if (-z $file) { 
				print "\nFinish job $id\n"; last;
			} else { 
				print "."; sleep (150);
}}}}

sub get_job_id {	
	my $string = $_[0]; #Your job 57752 ("python") has been submitted
	my $id;
	if ($$string =~ /Your job (\d+) \(\".*/) { $id = $1 }
	return $id;
}

sub sending_command {

	my $command = $_[0];
	my $stage = $_[1];
	my $round = $_[2];
	
	my @id;
	print "\n\n## Command: $command\n##\n";
	my $string = `$command`;
        my $id = &get_job_id(\$string);
	return $id;
}
sub get_size {
	my $size = -s $_[0]; #To get only size
	return $size;
}
sub fasta_file_splitter {
	# Splits fasta file and takes into account to add the whole sequence if it is broken
	my $file = $_[0];
	my $block = $_[1];
	my $ext = $_[2]; # fasta, fastq, loci, fa

	open (FH, "<$file") or die "Could not open source file. $!";
	print "\t- Splitting file into blocks of $block characters aprox ...\n";
	my $j = 0; my @files;
	while (1) {
		my $chunk;
	   	my @tmp = split ("\.".$ext, $file);
		my $block_file = $tmp[0]."_part-".$j."_tmp.".$ext;
		push (@files, $block_file);
		open(OUT, ">$block_file") or die "Could not open destination file";
		if (!eof(FH)) { read(FH, $chunk,$block);  
			if ($j > 0) { $chunk = ">".$chunk; }
			print OUT $chunk;
		} ## Print the amount of chars	
		if (!eof(FH)) { $chunk = <FH>; print OUT $chunk; } ## print the whole line if it is broken	
		if (!eof(FH)) { 
			$/ = ">"; ## Telling perl where a new line starts
			$chunk = <FH>; chop $chunk; print OUT $chunk; 
			$/ = "\n";
		} ## print the sequence if it is broken
		$j++; close(OUT); last if eof(FH);
	}
	close(FH);
	return (\@files);
}

1;