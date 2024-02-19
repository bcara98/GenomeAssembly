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

name=$(echo $i1| sed 's/\(^.*\)\(\/[^\/]*_.*fq.*$\)/\2/g')
name=$(echo $name| sed 's/\(^\/\)\(.*\)\(_.*fq.*$\)/\2/g')
conda activate $env
mkdir "$out"
mkdir "${out}/${out}_raw_qa"
echo "Starting Assembly for pair ${name}" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Running Falco" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "For read ${i1}" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time falco -o "${out}/${out}_raw_qa/1" $i1) 2>&1 | tee -a "${out}/${name}_long_log.log" 
echo "For read ${i2}" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time falco -o "${out}/${out}_raw_qa/2" $i2) 2>&1 | tee -a "${out}/${name}_long_log.log"
mkdir "${out}/${out}_trim"
echo "______________________________________" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Running Trimmomatic" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time trimmomatic PE -phred33 $i1 $i2 "${out}/${out}_trim/r1.paired.fq.gz" "${out}/${out}_trim/r1_unpaired.fq.gz" "${out}/${out}_trim/r2.paired.fq.gz" "${out}/${out}_trim/r2_unpaired.fq.gz" LEADING:4 TRAILING:4 MAXINFO:97:0.7 MINLEN:100 AVGQUAL:28) 2>&1 | tee "${out}/${out}_trim/trim_log.txt"
cat "${out}/${out}_trim/trim_log.txt" >> "${out}/${name}_long_log.log"
sed -i -n '3p' "${out}/${out}_trim/trim_log.txt"
cat "${out}/${out}_trim/trim_log.txt" | sed 's/\(^.*\)\([\(][0-9]\{1,\}\.[0-9]\{1,\}%[\)]\)\(.*\)\([\(][0-9]\{1,\}\.[0-9]\{1,\}%[\)]\)\(.*\)\([\(][0-9]\{1,\}\.[0-9]\{1,\}%[\)]\)\(.*\)\([\(][0-9]\{1,\}\.[0-9]\{1,\}%[\)]\)\(.*$\)/\2\4\6\8/g'|sed 's/[\(\)]//g'|sed 's/%/,/g' >> "${out}/${out}_trim/trim_vals.txt"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Removing unpaired Reads" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time rm -v "${out}/${out}_trim"/*unpaired*) 2>&1 | tee -a "${out}/${name}_long_log.log"
mkdir "${out}/${out}_raw_qa_trimmed"
echo "______________________________________" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Running Falco after trimming" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "For 1st trimmed paired read"2>&1 | tee -a "${out}/${name}_long_log.log"
(time falco -o "${out}/${out}_raw_qa_trimmed/1" "${out}/${out}_trim/r1.paired.fq.gz") 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "For 2nd trimmed paired read" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time falco -o "${out}/${out}_raw_qa_trimmed/2" "${out}/${out}_trim/r2.paired.fq.gz") 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "______________________________________" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Decompressing trimmed paired reads for megahit assembly" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Decompressing 1st paired trimmed read" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time pigz -d "${out}/${out}_trim/r1.paired.fq.gz") 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Decompressing 2nst paired trimmed read" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time pigz -d "${out}/${out}_trim/r2.paired.fq.gz") 2>&1 | tee -a "${out}/${name}_long_log.log"
rm -rf "${out}/${out}_asm"
echo "______________________________________" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Running megahit" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time megahit -1 "${out}/${out}_trim/r1.paired.fq" -2 "${out}/${out}_trim/r2.paired.fq" -o "${out}/${out}_asm" --min-count 5 --no-mercy) 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "______________________________________" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Recompressing trimmed paired reads" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Recompressing 1st paired trimmed read" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time pigz "${out}/${out}_trim/r1.paired.fq") 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Recompressing 2nd paired trimmed read" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time pigz "${out}/${out}_trim/r2.paired.fq") 2>&1 | tee -a "${out}/${name}_long_log.log"
mkdir "${out}/${out}_quast_out"
echo "______________________________________" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "Running QUAST" 2>&1 | tee -a "${out}/${name}_long_log.log"
(time quast.py "${out}/${out}_asm/final.contigs.fa" -o "${out}/${out}_quast_out") 2>&1 | tee "${out}/${out}_quast_out/asm_log.txt"
qvar=$(cat "${out}/${out}_quast_out/asm_log.txt")
echo "$qvar" >> "${out}/${name}_long_log.log"
echo $qvar|sed 's/\(^.* \)\(final\.contigs, \)\(N50 = .*\)\(, # N.*$\)/\3/g' > "${out}/${out}_quast_out/asm_log.txt"
echo "++++++++++++++++++++++++++++++++++++++" 2>&1 | tee -a "${out}/${name}_long_log.log"
echo "" >> "${out}/${name}_long_log.log"
echo "Assembly Processes for ${name} is complete" 2>&1 | tee -a "${out}/${name}_long_log.log"
