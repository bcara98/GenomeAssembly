#!/bin/bash

#This batch_quast script will do a quast assemsent among all of the contig files generated given a folder with the located contigs 

#env will be the conda environment with quast installed
env=""

#This will be the output folder
out=""

#configure variables above based on the given flag options
while getopts "e:o:" flag;
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

#activate the conda environment
conda activate $env

#paths with the contig files from megahit (uses wild cards)
indir="${out}/*/${out}*asm/final.contigs.fa"

#run the quast quality check in all those contig files generate a log file
(time quast.py -t 25 -o "${out}/quast_batch_report" $indir) 2>&1 | tee "${out}/quast_batch_log.log"

#exit conda environment
conda deactivate

