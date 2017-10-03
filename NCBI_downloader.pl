#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use FindBin;
use Parallel::ForkManager;
use Cwd qw(abs_path);  

my ($file, $option, $cpus, $help, $summary, $genome, $genbank, $gff);

GetOptions(
	"file=s" => \$file,
	"n=i" => \$cpus,
	"h|help" => \$help,
	"summary" => \$summary,
	"genome" => \$genome,
	"genbank" => \$genbank,
	"gff" => \$gff,
);

if (!$file) {
	print "\n\nUsage: perl $0 -file file -n cpus -genome|-genbank|-gff [-summary]\n";
	print "\t- file: contains name,ftp site\n";
	print "\t- summary: flag indicating multiple genomes to download\n\n";
	exit();
}

my $dirname = abs_path();
my %files2download;
if ($summary) {
	open (FILE, "$file");
	while (<FILE>) {
		my $line = $_;
		chomp $line;
		my @array = split(",", $line);
		chdir $dirname;		
		my $dir = $dirname."/".$array[0];
		mkdir $dir, 0755;
		chdir $dir;
	
		my $taxa = $array[0];
		print "+ Download file: $array[1]\n";
		system("wget --passive-ftp $array[1]"); 

		my @file_path = split("/", $array[1]);
		my $summary_file = $file_path[-1];
		my $out_file = "downloaded.txt";
	
		open (OUT, ">$out_file"); open (SUM, "$summary_file");
		while (<SUM>) {
			next if $_ =~ /^#/;
			my $line = $_; chomp $line;
			my @array = split("\t", $line);
		
			#print Dumper \@array; exit();
	
			## Get representative genome of taxa	
			if ($array[4] eq "representative genome") {
				if ($array[10] eq "latest") {
					my $suffix;
					my $preffix = $array[-1];
					my @array_pre = split("/", $preffix);
					$preffix .= "/".$array_pre[-1];
					if ($genome) {
						$suffix = "_genomic.fna.gz"
					} elsif ($genbank) {
						$suffix = "_genomic.gbff.gz";
					} elsif ($gff) {
						$suffix = "_genomic.gff.gz"
					} else {
						print "\n\n##################################\n\nPlease specify genome|genbank|gff flag to download\n\n##################################\n";
						exit();
					}
					$files2download{$array[7]}{"file"} = $preffix.$suffix;
					$files2download{$array[7]}{"dir"} = $dir;
					print OUT $array[7]."\t".$preffix.$suffix."\n";
					
		}}} close (SUM); close (OUT);
	} close (FILE)
} else {
	my $int = 0;
	open (FILE, "$file");
	while (<FILE>) {
		my $line = $_;
		chomp $line;
		my @array = split(",", $line);
		my $dir = $dirname."/".$array[0];
		if (-d $dir) {
			$int++;
			$files2download{$array[0]."_".$int}{"file"} = $array[1];
			$files2download{$array[0]."_".$int}{"dir"} = $dir;
		} else {
			mkdir $dir, 0755;
			$files2download{$array[0]}{"file"} = $array[1];
			$files2download{$array[0]}{"dir"} = $dir;
	}} close (FILE)
}

my $pm =  new Parallel::ForkManager($cpus); ## Number of subprocesses not equal to CPUs. Each subprocesses will have multiple CPUs if available
$pm->run_on_finish( 
sub { my ($pid, $exit_code, $ident) = @_; 
	print "\n\n** Child process finished with PID $pid and exit code: $exit_code\n\n"; 
} );
$pm->run_on_start( sub { my ($pid, $ident)=@_; print "\n\n** Downloading data for $ident\n\n"; } );

print "+ Parsing file and retrieving information for each genome within the group...\n";
foreach my $taxa (keys %files2download) {
	my $pid = $pm->start($taxa) and next;

	chdir $files2download{$taxa}{"dir"};	
	print $taxa." --> ".$files2download{$taxa}{"file"}."\n";	

	# Download
	my $file = $files2download{$taxa}{"file"};
	print "+ Download file: $file\n";
	system("wget --passive-ftp $file");
		
	# Gunzip file
	my @array_tmp = split("/", $file);
	my $file_downloaded = $array_tmp[-1];
	system("gunzip $file_downloaded");
	$pm->finish(); # pass an exit code to finish
}
$pm->wait_all_children; print "\n** All downloading steps are finished here...\n\n";


__END__
## Download NCBI data
# ftp://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_Downloading_Genomic_Data.pdf

# Steps

1. 	Download the /refseq/*/assembly_summary.txt file

# Archaea
ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/archaea/assembly_summary.txt

# Protozoa
ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/protozoa/assembly_summary.txt

# Virus
ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/viral/assembly_summary.txt

# Bacteria
ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt

# Fungi
ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/fungi/assembly_summary.txt


2. 	List the FTP path (column 20) for the assemblies of interest, in this case those that 
	have "Complete Genome" assembly_level (column 12) and "latest" version_status (column 11). 
	One way to do this would be using the following awk command:

awk -F "\t" '$12=="Complete Genome" && $11=="latest"{print $20}' assembly_summary.txt > ftpdirpaths

3. 	Append the filename of interest, in this case "*_genomic.gbff.gz" to the FTP directory names. One way to do this would be using the following awk command:

awk 'BEGIN{FS=OFS="/";filesuffix="genomic.gbff.gz"}{ftpdir=$0;asm=$6;file=asm"_"filesuffix;print ftpdir,file}' ftpdirpaths > ftpfilepaths

4. 	Use a script to download the data file for each FTP path in the list
