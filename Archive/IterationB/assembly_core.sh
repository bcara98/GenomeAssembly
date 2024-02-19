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
falco -o "${out}/${out}_raw_qa" $i1 $i2
mkdir "${out}/${out}_trim"
trimmomatic PE -phred33 $i1 $i2 "${out}/${out}_trim/r1.paired.fq.gz" "${out}/${out}_trim/r1_unpaired.fq.gz" "${out}/${out}_trim/r2.paired.fq.gz" "${out}/${out}_trim/r2_unpaired.fq.gz" SLIDINGWINDOW:5:20 2>&1 | tee "${out}/${out}_trim/trim_log.txt"
sed -i -n '3p' "${out}/${out}_trim/trim_log.txt"
rm -v "${out}/${out}_trim"/*unpaired*
falco -o "${out}/${out}_raw_qa_trimmed" "${out}/${out}_trim/r1.paired.fq.gz" "${out}/${out}_trim/r2.paired.fq.gz"
pigz -d "${out}/${out}_trim/r1.paired.fq.gz"
pigz -d "${out}/${out}_trim/r2.paired.fq.gz"
rm -rf "${out}/${out}_asm"
megahit -1 "${out}/${out}_trim/r1.paired.fq" -2 "${out}/${out}_trim/r2.paired.fq" -o "${out}/${out}_asm"
pigz "${out}/${out}_trim/r1.paired.fq"
pigz "${out}/${out}_trim/r2.paired.fq"
mkdir "${out}/${out}_quast_out"
quast.py "${out}/${out}_asm/final.contigs.fa" -o "${out}/${out}_quast_out" 2>&1 | tee "${out}/${out}_quast_out/asm_log.txt"
qvar=$(cat "${out}/${out}_quast_out/asm_log.txt")
echo $qvar|sed 's/\(^.* \)\(final\.contigs, \)\(N50 = .*\)\(, # N.*$\)/\3/g' > "${out}/${out}_quast_out/asm_log.txt"
