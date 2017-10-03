#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use FindBin;
use lib $FindBin::Bin."/lib2";
require myPackage;
use lib $FindBin::Bin."/lib";

require Cwd;
use Cwd qw(abs_path); 

my ($genome, $Pacbio_Reads, $outputDir, $nCPUs, $help, $nRounds, $PBJelly_path);

GetOptions( 
	"genome=s" => \$genome,
	"Pacbio_Reads=s" => \$Pacbio_Reads,
	"dir=s" => \$outputDir,
	"nCPUs=i" => \$nCPUs,
	"r|rounds=i" => \$nRounds,
	"PBJelly=s" => \$PBJelly_path,
	"h|help" => \$help,	
);

if (!$PBJelly_path) { &print_help(); exit(); }

# get path for dir where pacbio reads are
my $abs_reads = abs_path($Pacbio_Reads);
my @path = split("/", $abs_reads);
my $Pacbio_Reads_dir;
for (my $j=0; $j < @path -1; $j++) { $Pacbio_Reads_dir .= $path[$j]."/"; }
$Pacbio_Reads = $path[-1];

$genome = abs_path($genome);
$outputDir = abs_path($outputDir);
$PBJelly_path = abs_path($PBJelly_path);
my $cwd = abs_path(); # suponemos que hemos hecho un ln-s del fichero original

## We will not split pacbio reads as it is difficult to control within a node
## we would tell blasr to use as many cpus as specified

# split Pacbio reads into files..
print "\n##########################################################\n";
print "\nStarting pipeline for multiple rounds of gap-filling using PBJelly\n";
print "\n##########################################################\n";
print "\n+ Splitting Pacbio reads file into blocks...\n";
my $wc_out = `wc $Pacbio_Reads`;
$wc_out =~ s/\s+/-/g;
my @info = split("-", $wc_out);
my $size = $info[3];
my $lines = $info[1];

print "\tFile size: ".$size." bytes\n";
print "\tFile length: ".$lines." lines\n";
my $nJobs = int($nCPUs/4);
print "\tFile will be splitted into: $nJobs\n";
my $block = $size/$nJobs;
my $array_PacB_ref = myPackage::fastq_file_splitter($Pacbio_Reads, $block);

# generate a protocol in xml format
my $xml_file = $outputDir."/jellyProtocol_";
my $jelly_out_previous_round;
my (@reference, @protocols, @dirs);
for (my $j=1; $j <= $nRounds; $j++) {
	my $round_file = $xml_file."Round".$j.".xml";
	my $dir_round = $outputDir."/round".$j;	
	#$dir_round = abs_path($dir_round);
	mkdir ($dir_round, 0755);
	if ($j == 1) {
		&JellyProtocol($genome, $dir_round, $round_file);	
		push (@reference, $genome);
		push (@dirs, $outputDir);
	} else {
		## Re-Gap_Filling
		&JellyProtocol($jelly_out_previous_round, $dir_round, $round_file);	
		push (@dirs, $dir_round);
	}
	$jelly_out_previous_round = $dir_round."/jelly.out.fasta";
	push (@reference, $jelly_out_previous_round);
	push (@protocols, $round_file);
}

my $tmp_files = $outputDir."/tmp_info_files";
mkdir ($tmp_files, 0755);

for (my $p=0; $p < scalar @protocols; $p++) {
	print "\n######################################\n";
	my $round = $p+1;
	print "\tStarting Round $round\n";
	print "\n######################################\n";
	print "\nProtocol File: $protocols[$p]\n\n";
	
	## Generate Fake fastq
	my @name_split = split("\.fasta", $reference[$p]);
	my $qual_file = $name_split[0].".qual";
	if ($p > 0) {
		my $name = $reference[$p]."_original.qual";
		print "## Command: mv $qual_file $name ##\n";
		system("mv $qual_file $name");
	}

	my $string_fakeQuals = "qsub -cwd -V -q h10.q -pe ompi64h10 1 -b y python $PBJelly_path/fakeQuals.py $reference[$p] $qual_file";
	my $id = &sending_command($string_fakeQuals, "fake", $round);
	
	# Setup
	my $string_Setup = "python $PBJelly_path/Jelly.py setup $protocols[$p]\n";
	&sending_command($string_Setup, "setup", $round);

	#chdir $dirs[$p];
	# Mapping
	my $string_Mapping = "python $PBJelly_path/Jelly.py mapping $protocols[$p]\n";
	&sending_command($string_Mapping, "mapping", $round);

	# Support
	my $string_support = "python $PBJelly_path/Jelly.py support $protocols[$p]\n";
	&sending_command($string_support, "support", $round);

	# Extraction
	my $string_extraction = "python $PBJelly_path/Jelly.py extraction $protocols[$p]\n";
	&sending_command($string_extraction, "extraction", $round);

	# Assembly
	my $string_assembly = "python $PBJelly_path/Jelly.py assembly $protocols[$p]\n";
	&sending_command($string_assembly, "assembly", $round);

	# Output
	my $string_output = "python $PBJelly_path/Jelly.py output $protocols[$p]\n";
	&sending_command($string_output, "output", $round);
}

exit();


sub print_help {
	print "\n#######################################################################\n";
	print "\nThis scripts calls and generates n rounds of GapFilling using PBJelly.\n\n";
	print "Usage: perl $0\n";
	print "\t-genome: reference fasta file for gap filling\n";
	print "\t-Pacbio_Reads: fastq file of CCS reads\n";
	print "\t-dir: path\n";
	print "\t-nCPUs: number of CPUs to use\n";
	print "\t-r|rounds: number of rounds to perform\n";
	print "\t-PBJelly: path of executable\n";
	print "\t-h|help\n";
	print "\n#######################################################################\n\n";

}

sub JellyProtocol {
	
	my $ref = $_[0];
	my $dir = $_[1];
	my $file = $_[2];
	
	open (XML, ">$file");
	print XML "<jellyProtocol>\n";
	print XML "\t<reference>".$ref."</reference>\n";
	print XML "\t<outputDir>".$dir."</outputDir>\n";
	print XML "\t<cluster>\t\t<command>qsub -cwd -V -q h10.q -pe ompi64h10 4 -N \${JOBNAME}\ -o \${STDOUT} -e \${STDERR} \${CMD}</command>\n\t\t<nJobs>$nJobs</nJobs>\t</cluster>\n";
	print XML "\t<blasr>-minMatch 8 -minPctIdentity 70 -bestn 1 -nCandidates 20 -maxScore -500 -nproc 4 -noSplitSubreads</blasr>\n";
	print XML "\t<input baseDir=\"".$outputDir."\">\n"; ## asumiendo que hacemos ln-s en el directorio
	
	for (my $i=0; $i < scalar @$array_PacB_ref; $i++) {
		print XML "\t\t<job>".$$array_PacB_ref[$i]."</job>\n"; 
	}	
	print XML "\t</input>\n</jellyProtocol>\n";
}

sub get_job_id {	
	my $string = $_[0]; #Your job 57752 ("python") has been submitted
	my $id;
	if ($$string =~ /Your job (\d+) \(\".*/) { $id = $1 }
	return $id;
}

sub waiting {

	my $id_ref = $_[0];
	for (my $j=0; $j < scalar @$id_ref; $j++) {
		my $id = $$id_ref[$j];
		my $file = $tmp_files."/info_".$id.".txt";
		while (1) {
			my $out = system("qstat -j $id > $file");	
			my $finish;
			if (-z $file) { 
				print "\nFinish job $id\n"; last;
			} else { 
				print "."; sleep (60);
}}}}

sub sending_command {

	my $command = $_[0];
	my $stage = $_[1];
	my $round = $_[2];
	
	my @id;
	print "\n\n##\n## Round $round\n## Command: $command\n##\n";
	my $string = `$command`;

	if ($stage eq "fake") {
		my $id = &get_job_id(\$string); push (@id, $id);
	} else {
		my $tmp_file = $tmp_files."/tmp_".$stage."_R-".$round.".txt";
		my $qstat_system_call = system("/usr/bin/qstat > $tmp_file");
		print "Jobs ids to wait for:\n";		
		open (FILE, $tmp_file);
		while (<FILE>) {
			next if /^#/ || /^\s*$/;
			chomp;
			my $line = $_;	
			if ($line =~ /job\-ID.*/) {next;}
			if ($line =~ /^----.*/) {next;}	
			$line =~ s/\s/\t/g;
			$line =~ s/\t+/\t/g;
			my @array = split("\t", $line);
			my $result = &check_id(\$array[1]);
			if ($result == 1) {
				print "ID: $array[1]\n";
				push (@id, $array[1]);
			}
		}
		close (FILE);
		#if (($stage eq "setup") || ($stage eq "extraction") || ($stage eq "output")){
		#} elsif ( ($stage eq "mapping") || ($stage eq "assembly") || ($stage eq "support") ) {
		#}
	}
	my $message = &waiting(\@id);
}

sub check_id {

	my $id = $_[0];
	my $tmp_file = $tmp_files."/tmp_".$$id.".txt";
	my $out = system("qstat -j $$id > $tmp_file");
	my $ok=0;
	open (F, $tmp_file);
	while (<F>) { if ($_ =~ /.*$outputDir.*/g) { $ok = 1; }}
	close (F); return $ok;
}


# perl /users/jfsanchez/scripts/jfsh_scripts/calling_PBJelly.pl -genome /users/jfsanchez/cleanReads/6.Gap_Filling/test_PBSuite_toyData/lambda.fasta -Pacbio_Reads /users/jfsanchez/cleanReads/6.Gap_Filling/test_PBSuite_toyData/filtered_subreads.fastq -dir /users/jfsanchez/cleanReads/6.Gap_Filling/test_PBSuite_toyData/ -nCPUs 16 -r 4 -PBJelly /users/jfsanchez/JFSH_software/PacBio_Reads/PBSuite_15.8.24/bin/
# qsub_Serial_q0107 /users/jfsanchez/scripts/jfsh_scripts/CPU_blocker.sh 
