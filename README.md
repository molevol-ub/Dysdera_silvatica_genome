# Introduction
This is a small git repository of the scripts we used in the genome assembly, annotation and comparative analysis of the Dysdera silvatica genome prokect.

We basically include several scripts in perl, python or R. Some scripts might need additional perl/python/R modules in order to execute.

In some cases we include additional information within each script according the parameters employed or the data we used. All files are included under as supplementary information deposited in the GigaDB repository (link).

# Perl scripts
Some of this perl scripts are small and basic scripts that we basically collect here for the shake of reproducibility. Some others might contain more detailed algorithms. We briefly add a small piece of information on each one.


## contig_stats.pl

It generates contig statistics and metrics from a given assembly. 

    bash$ perl ./Dysdera_silvatica_genome/perl/contig_stats.pl

     Usage: please provide a single fasta file for Contig Statistics...
     perl perl/contig_stats.pl fasta_file

Notes:
- Sequences < 150pb would discarded for the statistics...
- Statistics are provided for different sets of sequences
- Default splitting sets: 150, 500, 1000, 5000, 10000
- Provide new parts using a csv argument for the script

      e.g. bash$perl ./Dysdera_silvatica_genome/perl/contig_stats.pl fasta_file 1000,15000

## get-long-contigs.pl & get-short-contigs.pl

Both scripts subset a given assembly fasta file selecting contigs bigger or smaller than the size selected.

     e.g. bash$ perl ./Dysdera_silvatica_genome/perl/get-long-contigs.pl assembly_file.fasta 10000
     e.g. bash$ perl ./Dysdera_silvatica_genome/perl/get-short-contigs.pl assembly_file.fasta 500


## NCBI_downloader.pl

We downloaded a set of sequences from NCBI in order to perform a quality and contaminant search. 

Following instructions available at NCBI data ftp://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_Downloading_Genomic_Data.pdf

We followed the next steps: 

1. 	Check assembly summary files from the RefSeq ftp site (/refseq/*/assembly_summary.txt) of the taxa of interest.

`````
Archaea: ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/archaea/assembly_summary.txt
Protozoa: ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/protozoa/assembly_summary.txt
Virus: ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/viral/assembly_summary.txt
Bacteria: ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
Fungi:ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/fungi/assembly_summary.txt
`````

e.g. refseq/bacteria/assembly_summary.txt
`````
#   See ftp://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt for a description of the columns in this file.
# assembly_accession    bioproject      biosample       wgs_master      refseq_category taxid   species_taxid   organism_name   infraspecific_name      isolate version_status  assembly_level  release_type    genome_rep      seq_rel_date    asm_name        submitter       gbrs_paired_asm paired_asm_comp ftp_path        excluded_from_refseq    relation_to_type_material
GCF_000010525.1 PRJNA224116     SAMD00060925            representative genome   438753  7       Azorhizobium caulinodans ORS 571        strain=ORS 571          latest  Complete Genome Major   Full    2007/10/16      ASM1052v1       University of Tokyo     GCA_000010525.1 identical       ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/010/525/GCF_000010525.1_ASM1052v1                assembly from type material
GCF_000007365.1 PRJNA224116     SAMN02604269            representative genome   198804  9       Buchnera aphidicola str. Sg (Schizaphis graminum)       strain=Sg               latest  Complete Genome Major   Full    2002/07/02      ASM736v1        Uppsala Univ.   GCA_000007365.1 identical       ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/007/365/GCF_000007365.1_ASM736v1         
GCF_000007725.1 PRJNA224116     SAMN02604289            representative genome   224915  9       Buchnera aphidicola str. Bp (Baizongia pistaciae)       strain=Bp (Baizongia pistaciae)         latest  Complete Genome Major   Full    2003/01/29      ASM772v1        Valencia Univ.  GCA_000007725.1 identical       ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/007/725/GCF_000007725.1_ASM772v1         
`````


2. 	Use the NCBI_downloader.pl script to download the data file for each FTP path.
      
        bash$ perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl 
        
        Usage: perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl -file file -n cpus -genome|-genbank|-gff [-summary]
      	
        - file: contains name,ftp site	      
        - summary: flag indicating multiple genomes to download

There are two possibilities here. 

1) Summary option. 

We can provide names of groups and path to assembly_summary ftp sites. The scripts downloads all the genomes available:

For example: Bacteria & Virus. Provide a csv file
        
        e.g. bash$ cat test.csv
        Virus,ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/viral/assembly_summary.txt
        Bacteria,ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt

Execute NCBI_downloader.pl to download genome information from each strain and using 3 threads.

        e.g. bash$ perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl -file test.csv -summary -n 3 -genome

`````
+ Download file: ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
--2019-07-08 20:02:55--  ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
          => “assembly_summary.txt”
Resolviendo ftp.ncbi.nlm.nih.gov (ftp.ncbi.nlm.nih.gov)... 130.14.250.11, 2607:f220:41e:250::10
Conectando con ftp.ncbi.nlm.nih.gov (ftp.ncbi.nlm.nih.gov)[130.14.250.11]:21... conectado.
Identificándose como anonymous ... ¡Dentro!
==> SYST ... hecho.   ==> PWD ... hecho.
==> TYPE I ... hecho.  ==> CWD (1) /genomes/refseq/bacteria ... hecho.
==> SIZE assembly_summary.txt ... 48346044
==> PASV ... hecho.   ==> RETR assembly_summary.txt ... hecho.
assembly_summary.txt                                                         10%[=================>                                                                                                                                                                         ]   4,67M   434KB/s   eta 2m 16s
.......

** Downloading data for Acetobacter aceti
Acetobacter aceti --> ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/005/445/GCF_002005445.1_ASM200544v1/GCF_002005445.1_ASM200544v1_genomic.fna.gz
+ Download file: ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/005/445/GCF_002005445.1_ASM200544v1/GCF_002005445.1_ASM200544v1_genomic.fna.gz
....
** Downloading data for Chryseobacterium indologenes
Chryseobacterium indologenes --> ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/025/665/GCF_002025665.1_ASM202566v1/GCF_002025665.1_ASM202566v1_genomic.fna.gz
+ Download file: ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/025/665/GCF_002025665.1_ASM202566v1/GCF_002025665.1_ASM202566v1_genomic.fna.gz
....
** Downloading data for Xanthomonas oryzae pv. oryzae PXO99A
Xanthomonas oryzae pv. oryzae PXO99A --> ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/019/585/GCF_000019585.2_ASM1958v2/GCF_000019585.2_ASM1958v2_genomic.fna.gz
.......

`````

This script would take some time to download all the information requested. 


2) Provide some examples: name and ftp site in a csv file

        e.g. bash$ cat example.csv
        GCF_000010525.1,ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/010/525/GCF_000010525.1_ASM1052v1
        GCF_000007365.1,ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/007/365/GCF_000007365.1_ASM736v1         
        GCF_000007725.1,ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/007/725/GCF_000007725.1_ASM772v1         

        e.g. bash$ perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl -file example.csv -n 3 -genome



## high_coverage_islands.pl

## high_coverage_islands2bed.pl

## get_taxonomy_IDs.pl

## taxonomy_parser.pl





# Citation
"The draft genome sequence of the spider Dysdera silvatica (Araneae, Dysderidae): A valuable resource for functional and evolutionary genomic studies in chelicerates" Sánchez-Herrero J. F., Frías-López C., Escuer P., Hinojosa-Alvarez S., Arnedo M.A., Sánchez-Gracia A., Rozas J. to add DOI and citation
