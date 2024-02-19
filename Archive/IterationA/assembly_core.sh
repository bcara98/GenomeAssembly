#!/bin/bash

env=""
pn=""
i1=""
i2=""
out=""

while getopts "e:1:2:o:" flag;
do
	case "$flag" in
		1)
			i1=$OPTARG
			;;
		2)	
			i2=$OPTARG
			;;
		o)
			out=$OPTARG
			;;

		e)
			env=$OPTARG
			;;

		*)
			;;
	esac

done
conda activate $env
mkdir "$out"
mkdir "${out}/${out}_raw_qa"
fastqc --threads 2 --outdir "${out}/${out}_raw_qa" $i1 $i2 -k 8
mkdir "${out}/${out}_trim"
trimmomatic PE -phred33 $i1 $i2 "${out}/${out}_trim/r1.paired.fq.gz" "${out}/${out}_trim/r1_unpaired.fq.gz" "${out}/${out}_trim/r2.paired.fq.gz" "${out}/${out}_trim/r2_unpaired.fq.gz" AVGQUAL:32 MAXINFO:40:0.5 LEADING:32 TRAILING:32
rm -v "${out}/${out}_trim"/*unpaired*
pigz -d "${out}/${out}_trim/r1.paired.fq.gz"
pigz -d "${out}/${out}_trim/r2.paired.fq.gz"
rm -rf "${out}/${out}_asm"
megahit -1 "${out}/${out}_trim/r1.paired.fq" -2 "${out}/${out}_trim/r2.paired.fq" -o "${out}/${out}_asm" --min-count 3 --no-mercy
pigz "${out}/${out}_trim/r1.paired.fq"
pigz "${out}/${out}_trim/r2.paired.fq"
mkdir "${out}/${out}_quast_out"
quast.py "${out}/${out}_asm/final.contigs.fa" -o "${out}/${out}_quast_out"
