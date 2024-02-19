#!/bin/bash

env=""
out=""
loc=""
num=""
srv=""

while getopts "e:s:l:p:o:" flag;
do
	case "$flag" in

		e)
			env=$OPTARG
			;;
		s)
			srv=$OPTARG
			;;

		l)
			loc=$OPTARG
			;;
		p)
			num=$OPTARG
			;;
		o)
			out=$OPTARG
			;;
		*)
			;;
	esac

done
list=$(rfastq -s "$srv" -p "$num" -l "$loc" -v|tail -n +3)
list=$(echo "$list"|sed 's/\(^.*_\)\(.*$\)/\1/g'|sed -n '1~2!p')
mkdir "$out"
echo "$list"|awk -v out_v=$out -v env_v=$env '{out_l=out_v"_"$1; out_r=out_v; system("bash -i ~/bin/assembly_core.sh -e "env_v" -1 "$1"1.fq.gz -2 "$1"2.fq.gz -o "out_l); system("mv "out_l" "out_r)}'
