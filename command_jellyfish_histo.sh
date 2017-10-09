#! /bin/bash -x
#$ -cwd
#$ -V

## $1: fasta/fastq file(s)
## $2: output file
## $3: kmer length

[ $# -eq 0 ] && { echo "
#################################################################
Count kmers and generate histogram given a fasta or fastq file using jellyfish

Usage: 
$0 file output kmer_length

#################################################################
";

exit 1; }


# count kmers
jellyfish count -C -s 5G -m $3 -t 24 -o $2 $1

# generate histo
jellyfish histo -t 24 -o $1.histo $2
