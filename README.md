- [Introduction](#introduction)
- [Citation](#heading-1)
- [Additional information](#heading-2)
  * [Note on GigaScience DB entry](#sub-heading-1)
    + [Concerns about the data](#sub-sub-heading-1)
- [Documentation](#heading-3)
  * [Sequence manipulation](#sub-heading-1)
  * [Download NCBI reference genomes](#sub-heading-2)
  * [High Coverage Regions (HCR)](#sub-heading-3)
  * [Coverage distribution](#sub-heading-4)
  * [Annotation](#sub-heading-5)
  * [Taxonomy profile](#sub-heading-6)
- [License](#license)


# Introduction

Copyright (c) 2019 Evolutionary Genomics & Bioinformatics 

This is a small git repository of the scripts we used in the genome assembly, annotation and comparative analysis of the Dysdera silvatica genome prokect.

We include several scripts in perl, python or R. Some scripts might need additional perl/python/R modules in order to execute that we have not included here.

In some cases we include additional information within each script according the parameters employed or the data we used. All necessary files to reproduce results are included as supplementary information deposited in the GigaDB repository (link) in the paper associated to this publication.

# Citation
The draft genome sequence of the spider Dysdera silvatica (Araneae, Dysderidae): A valuable resource for functional and evolutionary genomic studies in chelicerates.
Jose Francisco Sánchez-Herrero, Cristina Frías-López, Paula Escuer, Silvia Hinojosa-Alvarez, Miquel A Arnedo, Alejandro Sánchez-Gracia, Julio Rozas
GigaScience, Volume 8, Issue 8, August 2019, giz099, https://doi.org/10.1093/gigascience/giz099

# Additional information 
There is additional information regarding this publication and draft reference genome that you would be able to find here:

- NGS raw data file (NCBI BioProject entry): https://www.ncbi.nlm.nih.gov/bioproject/PRJNA475203

- Genome fasta file (NCBI Assembly entry): https://www.ncbi.nlm.nih.gov/assembly/GCA_006491805.1

- Annotation and other supporting information (GigaScience Database Entry): http://gigadb.org/dataset/100628 


## Note on GigaScience DB entry
Within the supporting data available in GigaScience database you should be able to find:

- annotation_Dsilvatica.gff.tar.gz  -  Genome Feature Format (GFF) file containing coding gene annotations
- annotation_Dsilvatica-proteins.fasta  -  Protein Coding gene translated sequences (fasta format)
- annotation_Dsilvatica-transcripts.fasta  -  Proteing Coding gene nucleotide sequences (fasta format)
- Dsilvatica_refGuided_transcriptome.fasta  -  Reference guided transcriptome assembly (fasta format)
- Dsilvatica_repeats.gff.tar.gz  -  Repeat annotations (txt format)
- Dsilvatica_repeats-lib.fasta  -  Repeat families (fasta format)
- seqs2discard.txt  -  Sequences discarded from the original draft while uploading to NCBI (txt format)

### Concerns about the data

We have noticed that there is an incongruency in fasta name headers between the NCBI Genbank genome fasta version and the GFF
file we provided within the GigaScience DB making this annotation useless. Then, it is mandatory to generate a name
conversion before any further analysis are processed. 

We propose this command but many others might be available.

XX

Additionally, during the uploading and validation into NCBI Genbank some sequences were discarded due to putative contaminations.
This sequences are included in seqs2discard.txt file available within the GigaScience DB entry and so they should be discarded too 
from the GFF file provided there.

Again, we propose this command to remove these entries from NCBI but some others might be available. 

XX

# Documentation

Some of this scripts are small and basic scripts that we basically collect here for the shake of reproducibility. Some others might contain more detailed algorithms. We briefly add a small piece of information on each one in the context of the process it was employed.

## Sequence manipulation

There are some procedures that we need to perform with our sequences such as:

-  Get sequences longer or shorter than a given length. We employed get-long-contigs.pl or get-short-contigs.pl
Both scripts subset a given assembly fasta file selecting contigs bigger or smaller than the size selected.

     e.g. bash$ perl ./Dysdera_silvatica_genome/perl/get-long-contigs.pl assembly_file.fasta 10000
     e.g. bash$ perl ./Dysdera_silvatica_genome/perl/get-short-contigs.pl assembly_file.fasta 500

- Generates contig statistics and metrics from a given assembly using [contig_stats.pl](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/perl/contig_stats.pl). 

        bash$ perl ./Dysdera_silvatica_genome/perl/contig_stats.pl

        Usage: please provide a single fasta file for Contig Statistics...
        perl perl/contig_stats.pl fasta_file

Notes:
- Sequences < 150pb would be discarded for the statistics...
- Statistics are provided for different sets of sequences
- Default splitting sets: 150, 500, 1000, 5000, 10000
- Provide new parts using a csv argument for the script

      e.g. bash$perl ./Dysdera_silvatica_genome/perl/contig_stats.pl fasta_file 1000,15000

## Download NCBI reference genomes

We downloaded a set of sequences from NCBI in order to perform a quality and contaminant search. 

Following instructions available at NCBI factsheet: [How to download data](ftp://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_Downloading_Genomic_Data.pdf)

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

2. 	Use the [NCBI_downloader.pl](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/perl/NCBI_downloader.pl) script to download the data file for each FTP path.
      
        bash$ perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl 
        
        Usage: perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl -file file -n cpus -genome|-genbank|-gff [-summary]
      	
        - file: contains name,ftp site	      
        - summary: flag indicating multiple genomes to download

There are two possibilities here. 

1) Summary option. 

We can provide names of groups and path to assembly_summary ftp sites. The scripts downloads all the genomes available:

For example: Bacteria & Virus. Provide a csv file like:
        
        e.g. bash$ cat test.csv
        Virus,ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/viral/assembly_summary.txt
        Bacteria,ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt

Execute NCBI_downloader.pl to download genome information from each strain and using 3 threads. It would initially download the assembly summary file to then retrieve each entry.

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

Command:

    e.g. bash$ perl ./Dysdera_silvatica_genome/perl/NCBI_downloader.pl -file example.csv -n 3 -genome

This script would take some time according to the amount of samples provided.

## High Coverage Regions (HCR)

This high_coverage_islands.pl script generates information regarding high-coverage regions. Given a mean coverage and contig lengths, it determines regions with a high coverage fulfilling different length and deviation from the coverage mean cutoff provided. See additional information in the paper cited. See below examples of High coverage regions.

![Example Plot coverage](example/HCR.png)

This image is an example plot generated where the coverage per base pair is shown in black and mean coverage is shown as a purple dot line. In green and orange dot lines, we plotted 2.5-5 times the average coverage cutoff. In blue we showed the intra gap length and in red the inter-repeat gap length. [Click image to see details].

Usage:

    bash$ perl ./Dysdera_silvatica_genome/perl/high_coverage_islands.pl \
    mean_coverage coverage_file length_cutoff output_file CPu   \
    intra_gap_cutoff length_file coverage_cutoff

Notes:

- **coverage_file** is a coverage file generated using samtools from sort indexed bam file. It must include positions with 0 values if any

```
sequence_6091	1	0
sequence_6091	2	0
sequence_6091	3	0
sequence_6091	4	0
sequence_6091	5	0
sequence_6091	6	0
sequence_6091	7	0
sequence_6091	8	0
sequence_6091	9	1
sequence_6091	10	1
sequence_6091	11	1
sequence_6091	12	1
sequence_6091	13	1
sequence_6091	14	1
sequence_6091	15	1
sequence_6091	16	2
sequence_6091	17	2
...
sequence_6091	2658	57
sequence_6091	2659	62
sequence_6091	2660	63
sequence_6091	2661	63
sequence_6091	2662	65
...
sequence_6091	24649	12
sequence_6091	24650	12
sequence_6091	24651	11
sequence_6091	24652	9
sequence_6091	24653	9
sequence_6091	24654	9
sequence_6091	24655	8
sequence_6091	24656	8
sequence_6091	24657	8
sequence_6091	24658	8
sequence_6091	24659	7
`````

(Previous image was generated using the R script [Plot_Example_HighCoveraIsland.R](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/R_scripts/Plot_Example_HighCoveraIsland.R) and a coverage file information for a selected contig.)

- To obtain the **mean coverage** you can do: 
        
        awk '{ sum +=$3; n++ } END { if (n > 0) print sum / n; }' coverage_file.txt

- **length_cutoff**: Minimun length cutoff for contig sequences. e.g. 30000

- **intra_gap_cutoff**: Inter-HCR minimum length. it can be a single value or comma separated values: 50 or 50,100,500

- **length_file**: For each contig, provide the sequence length. To do so, we will employ the script add it here named: [get-size-contigs.pl](perl/get-size-contigs.pl)

        bash$ perl ./Dysdera_silvatica_genome/perl/get-size-contigs.pl contigs.fasta

- **coverage_cutoff**: The amount of times to increase the mean coverage to consider it over the the threshold. e.g. 2.5, 5, 10...


This high_coverage_islands.pl script generates this output. For additional details, check supplementary files and information in the original paper:

```
sequence_10003  150     24752   4       repeat_1        -       -       -       6338    6508    170
sequence_10003  150     24752   4       repeat_2        6509    11083   4574    11084   11776   692
sequence_10003  150     24752   4       repeat_3        11777   20259   8482    20260   21098   838
sequence_10003  150     24752   4       repeat_4        21099   22039   940     22040   22497   457
sequence_10003  500     24752   2       repeat_1        -       -       -       11084   11776   692
sequence_10003  500     24752   2       repeat_2        11777   20259   8482    20260   21098   838
sequence_10005  10      13790   4       repeat_1        -       -       -       9668    10197   529
sequence_10005  10      13790   4       repeat_2        10198   10335   137     10336   11212   876
sequence_10005  10      13790   4       repeat_3        11213   11250   37      11251   11749   498
sequence_10005  10      13790   4       repeat_4        11750   13191   1441    13192   13270   78
sequence_10005  150     13790   3       repeat_1        -       -       -       9668    10197   529
sequence_10005  150     13790   3       repeat_2        10198   10335   137     10336   11212   876
sequence_10005  150     13790   3       repeat_3        11213   11250   37      11251   11749   498
sequence_10005  500     13790   2       repeat_1        -       -       -       9668    10197   529
sequence_10005  500     13790   2       repeat_2        10198   10335   137     10336   11212   876
sequence_10011  10      14044   2       repeat_1        -       -       -       7090    7175    85
sequence_10011  10      14044   2       repeat_2        7176    7657    481     7658    7782    124
sequence_10011  150     14044   1       repeat_1        -       -       -       8016    8201    185
sequence_10010  10      12713   2       repeat_1        -       -       -       449     1347    898
sequence_10010  10      12713   2       repeat_2        1348    1359    11      1360    1372    12
sequence_10010  150     12713   2       repeat_1        -       -       -       449     1347    898
sequence_10010  150     12713   2       repeat_2        1348    1484    136     1485    1715    230
sequence_10010  500     12713   1       repeat_1        -       -       -       449     1347    898
```

Then, using the script high_coverage_islands2bed.pl, we convert outfile from high_coverage_islands.pl into bed format for further analysis and intersection of annotation with the structural and functional annotation.

    bash$ perl ./Dysdera_silvatica_genome/perl/high_coverage_islands2bed.pl 
    
    Usage:
    perl ./Dysdera_silvatica_genome/perl/high_coverage_islands2bed.pl HCI_out_file name


    e.g. perl ./Dysdera_silvatica_genome/perl/high_coverage_islands2bed.pl subset_10kb.scaffolds_2.5x_coverage.HCI_5000.txt HCI_5000.bed
    
Using Bedtools we would intersect the annotation of the HCR regions with functional, structural or repeat annotation. 

    bedtools intersect -wao -a HCI_5000.bed -b Dsil_repeatMasker.bed > intersection_annotation.bed

In order to convert repeatmasker annotation into bed format, we developed and script included here and named as [repeatMasker2bed.py](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/python/repeatMasker2bed.py)

    bash$ python ./Dysdera_silvatica_genome/python/repeatMasker2bed.py repeatMasker.out output_name
 
 e.g. repeatMasker.out file:
 ```
    SW   perc perc perc  query           position in query        matching           repeat              position in repeat
score   div. del. ins.  sequence        begin  end      (left)   repeat             class/family      begin  end    (left)      ID

  332   10.0  4.0  0.0  sequence_1           1     50  (70697) C rnd-4_family-326   Unknown             (76)     52      1       1  
  324   17.7  0.0  0.0  sequence_1          60    121  (70626) C rnd-1_family-636   Unknown              (0)     64      3       2  
  996   12.7  1.3  0.6  sequence_1         129    287  (70460) C rnd-1_family-547   Unknown              (0)    160      1       3 *
 1848   10.8  4.5  0.0  sequence_1         273    610  (70137) + rnd-1_family-473   Unknown                1    307    (0)       4  
  252   17.4  0.0  0.0  sequence_1         596    641  (70106) C rnd-4_family-326   Unknown             (30)     98     53       5 *
  308   12.5  0.0  0.0  sequence_1         620    667  (70080) C rnd-4_family-711   Unknown              (0)     48      1       6  
 3368    6.8  0.4  0.4  sequence_1        1167   1562  (69185) C rnd-1_family-688   Unknown              (0)    458     63       7  
 2797   11.1  2.2  0.2  sequence_1        1563   1976  (68771) C rnd-1_family-168   DNA/TcMar-Pogo       (0)    422      1       8  
 1057    5.2 10.3  1.2  sequence_1        1977   2131  (68616) + rnd-1_family-943   Unknown                1    169    (0)       9  
  656   13.2  0.9  0.0  sequence_1        2129   2234  (68513) C rnd-6_family-3308  SINE/ID            (130)    748    642      10 *
 ```

e.g. repeatMasker2bed output file

````
sequence_1      1       50      rnd-4_family-326==Unknown       332     +
sequence_1      60      121     rnd-1_family-636==Unknown       324     +
sequence_1      129     287     rnd-1_family-547==Unknown       996     +
sequence_1      273     610     rnd-1_family-473==Unknown       1848    +
sequence_1      596     641     rnd-4_family-326==Unknown       252     +
sequence_1      620     667     rnd-4_family-711==Unknown       308     +
sequence_1      1167    1562    rnd-1_family-688==Unknown       3368    +
sequence_1      1563    1976    rnd-1_family-168==DNA/TcMar-Pogo        2797    +
sequence_1      1977    2131    rnd-1_family-943==Unknown       1057    +
sequence_1      2129    2234    rnd-6_family-3308==SINE/ID      656     +
````

Finally, we need to collect the amount of repeats in the whole genome and in the subset we want to analyzed.

e.g. count of repeat types in the whole genome.
```
DNA/TcMar-Tc4   21816
DNA/Zisupton    1953
LINE    274771
LINE/CR1        3223
LINE/Dong-R4    21921
Low_complexity  41405
LTR     22969
LTR/Copia       1775
RC/Helitron     2444
rRNA    851
Satellite       4890
SINE?   12984
SINE/ID 143670
Unknown 1840236
```

Then, we would analyze if they were significantly different, the amount for each type in the genome and the subset, using the cumulative distribution function under a [hipergeometric distribution](https://en.wikipedia.org/wiki/Hypergeometric_distribution). Credit to [Damian Kao](https://www.biostars.org/p/66729/)


We analyzed several intra repreat cutoff and coverage cutoff and we generated a bash script, [HCR_commands.sh](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/bash/HCR_commands.sh), to automatize the process.

Finally, we plotted results using different R scripts:
- [Plot_HCR_length.R](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/R_scripts/Plot_HCR_length.R): to plot intra and inter gap length distribution for each set.

- [bar_plot_HCR.R](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/R_scripts/bar_plot_HCR.R): to plot annotation of repeats for each set.

![High Coverage Region Annotation](example/HCR_annotation.png)


## Coverage distribution

For each sequencing run generated, we mapped reads against the assembled genome and generate using samtools coverage files (including 0 value positions). Using an estimated genome size and the different files we plotted the coverage distribution, discarding values smaller than 2x for a better visualization and the mean values for each sequencing run (dash lines)

e.g. example of coverage distributions

![Coverage distribution](example/coverage_sequencing_run.png)

## Annotation

Annotation was performed using iterative annotation rounds following maker documentation. We trained AUGUSTUS, SNAP and generated different models from BUSCO single copy parameters. We followed the instructions that we prepare for the [Functional Genome Annotation Workshop](https://github.com/JFsanchezherrero/Functional_Genome_Annotation) under the [AdaptNet](https://adaptnet.es/) workshop. Please check additional details in the paper and supplementary information. 

Annotation statistics provided by Maker were plot after each annotation, training and final round, to check the quality of the annotation generated.

AED statistics were retrieved using a simple bash script from each protein fasta file annotated in each round. 

     grep '>' fasta_input_file | awk '{print $1":"$3}' | perl -ne '@array=split(":", $_); $array[0]=~ s/^>//; print $array[0]."\t".$array[2];' > outputfile

Then, statistics were plotted for each annotation round using the R script [AED_statistics_plot.R](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/R_scripts/AED_statistics_plot.R)

e.g. Annotation Edit Distance statistics
![Annotation Edit Distance statistics](example/AED_statistics.png)

The quality index provided by maker was plot also for different sets using the R script [QI_data.R](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/R_scripts/QI_data.R)

e.g. Annotation Quality Index statistics
![Annotation Quality Index statistics](example/QI_statistics.png)


## Taxonomy profile    
Once we got protein-coding genes annotated from our draft assembly, we checked the taxonomy profile of this protein sequences. We retrieved several proteins fasta sequences from a broad amoung of arthropods. We added a tag to each protein id according to the species of origin and we generated a BLASTP search. Then, we parse best hits and get taxonomy of the hits identified to later plot using R.

We employed three different scripts and we followed the next steps:

[get_taxonomy_IDs.pl](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/perl/get_taxonomy_IDs.pl)

This script basically filters e-value < 1e-03 and retains the best hit for each protein and for each different taxa.

e.g. for a given protein from Dsilvatica (first column), several hits from others were retrieve in the second column and a uniq description of the taxa was added in the third column.

     bash$ perl ./Dysdera_silvatica_genome/perl/get_taxonomy_IDs.pl BLAST_UNIPROT > taxonomy.txt

e.g. taxonomy.txt file
```
bash$ head taxonomy.txt
snap_masked-Dsil_Scaffv1_471245-processed-gene-0.1-mRNA-1       LHES_6943,LREC_1431,PTEP_3636   LHES,LREC,PTEP
snap_masked-sequence_64407-processed-gene-0.2-mRNA-1    LPOL_831        LPOL
maker-sequence_33508-snap-gene-0.0-mRNA-1       Agen_74014,Cscult_19488,Cscult_5490,LPOL_14821,LPOL_8682,LPOL_8683,Mmartensi_14445,Mmartensi_19707,PTEP_28629,PTEP_28630,Smartitima_13564,Smimosarum_6457       Agen,Cscult,LPOL,Mmartensi,PTEP,Smartitima,Smimosarum
```

[taxonomy_parser.pl](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/perl/taxonomy_parser.pl)

Then, using an phylogenetic inclusive strategy specifically designed for this example, we selected the broadest group available for each protein. e.g. if we find a protein in any spider, but only from the araneomorphae group, we would assign Dsilvatica protein into that phylogenetic context. if we find a hit between any spider, arthropods and C.elegans at the same time, we could say that this protein would be present in any ecdysozoa.

We established different levels according to Dsilvatica phylogenetic context: 

```
Haplogynae	LREC
araneomorphae	Smimosarum,LHES,LREC,PTEP	
araneae	Agen,LHES,LREC,Smimosarum,PTEP
arachnida	Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
chelicerata	LPOL,Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
arthropoda	Dmel,Bmori,Phumanus,Dpul,Smartitima,Hdujardini,LPOL,Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
ecdysozooa	Celegans,Dmel,Bmori,Phumanus,Dpul,Smartitima,Hdujardini,LPOL,Agen,LHES,LREC,Smimosarum,Mmartensi,Cscult,Emaynei,Iscapularis,Turticae,Moccidentalis,PTEP
```

Command:

     bash$ perl ./Dysdera_silvatica_genome/perl/taxonomy_parser.pl taxonomy.txt > Summary.txt

e.g. Summary output
```
bash$ head Summary.txt
snap_masked-Dsil_Scaffv1_471245-processed-gene-0.1-mRNA-1   LHES_6943,LREC_1431,PTEP_3636   LHES,LREC,PTEP  araneomorphae
snap_masked-sequence_64407-processed-gene-0.2-mRNA-1	LPOL_831	LPOL	chelicerata
maker-sequence_33508-snap-gene-0.0-mRNA-1	Agen_74014,Cscult_19488,Cscult_5490,LPOL_14821,LPOL_8682,LPOL_8683,Mmartensi_14445,Mmartensi_19707,PTEP_28629,PTEP_28630,Smartitima_13564,Smimosarum_6457	Agen,Cscult,LPOL,Mmartensi,PTEP,Smartitima,Smimosarum	arthropoda
```

Then, we will basically summaryzed statistics from column 3 and plot them using R script [PieChart_Taxonomy.R](https://github.com/molevol-ub/Dysdera_silvatica_genome/blob/master/R_scripts/PieChart_Taxonomy.R)

e.g. pie chart plot for taxonomy distribution

![Taxonomy profile](example/taxonomy.png)


# License

MIT License

Copyright (c) 2019 Evolutionary Genomics & Bioinformatics 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


