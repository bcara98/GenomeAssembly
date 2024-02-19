#!/bin/bash

num=""
srv=""
loc=""
verb=0

while getopts "s:l:p:v" flag;
do
	case "$flag" in
		s)
			srv=$OPTARG
			;;
		p)	
			num=$OPTARG
			;;
		l)
			loc=$OPTARG
			;;
		v)
			verb=1
			;;
		*)
			;;
	esac
done


len=${#loc}
tabbed=""
for i in {1..$len}
do
  tabbed+="\t\t\t\t"
done

read -sp "Enter your server password: " pwd

echo ""

list=$(sshpass -p $pwd ssh -t $srv ls -sh $loc)
list=$(echo "$list"|sed -e 's/\( \{1,\}\)/ /g'|sed -e 's/\t\{1,\}/\n/g'|sed 's/\(^ \)\(.*\)/\2/g'|sed 's/ /\n/2;P;D'|sort -h|tail -n +3|cut -f 2 -d ' '|sed 's/\r//g'||sed 's/\x0/\t/g'|tail -n +2)

arr_list=()
temp=""
char=""
NL=$'\n'
for (( i=0; i<${#list}; i++ ))
do
	char="${list:$i:1}"
	if [ "$char" = "$NL" ];
	then
		arr_list+=("$temp")
		temp=""
	else
		temp="${temp}${char}"
	fi
	
done
count=0
arr_filter=()
for i in "${arr_list[@]}"
do
	:
	# do whatever on "$i" here
	name=$(echo $i|sed 's/\(^.*_\)\(.*$\)/\1/g')
	if [[ " ${arr_filter[*]} " == *" $i "* ]]; then
		true
	else
		fname="${name}1.fq.gz"
		arr_filter+=("$fname")
		fname="${name}2.fq.gz"
		arr_filter+=("$fname")
		count=$((count+1))
	fi
	if [ "$count" -ge "$num" ]; then
		break
	fi
done

list_filter=""

for i in "${arr_filter[@]}"
do
	:
	list_filter="${list_filter}${NL}${i}"
done

echo "$list_filter"|tail -n +2|sed "s|\(.*\)|$loc$tabbed\/\1\ \1|g"|sed 's/\t//g'|sed 's/ /\t/g'|sed 's/\x0/\t/g'|sed 's/\(^0\)\(.*$\)/\1/'|awk -v pwd_in=$pwd -v srv_in=$srv -v verb_in=$verb '{if (verb_in==0){print "Retrieving file "$2" from server"}; system("sshpass -p "pwd_in" scp "srv_in":"$1" "$2);}'

if [ "$verb" == 1 ]; then
	echo "$list_filter"
fi



