#! /bin/bash -x
#$ -cwd
#$ -V

## $1 is file containing patterns
## $2 is the file to search
for i in `cat $1`;
do
	command="grep -w -c '$i' $2"
	out=$(eval $command)
	echo $i"\t"$out
done;