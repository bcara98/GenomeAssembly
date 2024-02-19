#!/bin/bash
num=$1
srv=$2
loc=$3
len=${#loc}
tabbed=""
for i in {1..$len}
do
  tabbed+="\t\t\t\t"
done

read -sp "Enter your server password: " pwd


list=$(sshpass -p $pwd ssh -t $srv ls -sh $loc)
list=$(echo "$list"|sed -e 's/\( \{1,\}\)/ /g'|sed -e 's/\t\{1,\}/\n/g'|sed 's/\(^ \)\(.*\)/\2/g'|sed 's/ /\n/2;P;D'|sort -h|tail -n +3|cut -f 2 -d ' '|sed 's/\r//g'|sed "s|\(.*\)|$loc$tabbed\/\1\ \1|g"|sed 's/\t//g'|sed 's/ /\t/g'|sed 's/\x0/\t/g')

echo "$list"|sed 's/\(^0\)\(.*$\)/\1/'|head -n $num|awk -v pwd_in=$pwd -v srv_in=$srv '{print "Retrieving file "$2" from server"; system("sshpass -p "pwd_in" scp "srv_in":"$1" "$2);}'

