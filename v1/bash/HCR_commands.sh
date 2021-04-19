#! /bin/bash -x
#$ -cwd
#$ -V

## file $1
## name $2
## length $3

mkdir $2
cd $2

subset='HCI_subset_intra_gap_'$2'_'$3
subset_HCI='HCI_subset_'$2'_'$3
awk '{if ($11 > '$3' ) { print $8 }}' $1 | grep -v '-' > $subset'.txt'
awk '{if ($11 > '$3' ) { print $0 }}' $1 | grep -v '-' > $subset_HCI'.txt'

## get subset and convert to bed
perl ./Dysdera_silvatica_genome/perl/high_coverage_islands2bed.pl $subset_HCI'.txt' $subset_HCI'.bed' 

## get intersection
intersectBed -wao -a $subset_HCI'.bed' -b Dsil_repeatMasker.bed > intersection.bed

## count repeats
awk '{print $10}' intersection.bed | grep -w -v '\.' |  sed 's/==/\t/' | sort > repeats_and_types.txt
awk '{print $1}' repeats_and_types.txt > repeats_names.txt
awk '{print $2}' repeats_and_types.txt > types_names.txt
##
sh ./Dysdera_silvatica_genome/bash/grepCount_command.sh Dsil_repeatMasker.categories_names_uniq.txt repeats_names.txt > repeats_count.txt
sh ./Dysdera_silvatica_genome/bash/grepCount_command.sh Dsil_repeatMasker.categories_type_uniq.txt types_names.txt  > types_count.txt

cut -f2 repeats_count.txt | paste -d '\t' Dsil_repeatMasker.categories_namesCount.txt - > count_table_names.txt
cut -f2 types_count.txt | paste -d '\t' Dsil_repeatMasker.categories_typeCount.txt - > count_table_type.txt

## get total population
population=($(wc Dsil_repeatMasker.bed ))
## get total subset
subset=($(wc repeats_and_types.txt))

## type
while read name total1 set1
do
   `python ./Dysdera_silvatica_genome/python/numpy_hypergeometric.py ${population[0]} $total1 ${subset[0]} $set1 $name >> table_type.txt`;
done < count_table_type.txt


## names
while read name total1 set1
do
	`python ./Dysdera_silvatica_genome/python/numpy_hypergeometric.py ${population[0]} $total1 ${subset[0]} $set1 $name >> table_names.txt`;
done < count_table_names.txt

