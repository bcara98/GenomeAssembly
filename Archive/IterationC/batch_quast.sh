#!/bin/bash

env=""
out=""

while getopts "e:l:p:o:" flag;
do
	case "$flag" in

		e)
			env=$OPTARG
			;;
		o)
			out=$OPTARG
			;;
		*)
			;;
	esac

done

conda activate $env

indir="${out}/*/${out}*asm/final.contigs.fa"

(time quast.py -t 25 -o "${out}/quast_batch_report" $indir) 2>&1 | tee "${out}/quast_batch_log.log"

conda deactivate

