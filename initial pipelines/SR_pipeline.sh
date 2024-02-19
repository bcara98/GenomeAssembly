#!/usr/bin/bash
#Fetching files from the shell server 
scp srajasekar7@biogenome2023.biosci.gatech.edu:/home/team2/Raw_FQs/CGT2006_*fq.gz ~/Downloads
scp srajasekar7@biogenome2023.biosci.gatech.edu:/home/team2/Raw_FQs/CGT2010_*fq.gz ~/Downloads
scp srajasekar7@biogenome2023.biosci.gatech.edu:/home/team2/Raw_FQs/CGT2044_*fq.gz ~/Downloads
scp srajasekar7@biogenome2023.biosci.gatech.edu:/home/team2/Raw_FQs/CGT2049_*fq.gz ~/Downloads
scp srajasekar7@biogenome2023.biosci.gatech.edu:/home/team2/Raw_FQs/CGT2060_*.fq.gz ~/Downloads

#Create new environment 
conda create -n asm1 -y
conda activate asm1
#Install fastp 
conda install -c bioconda fastp 
fastp --version 
#Running fastp
fastp -i CGT2006_1.fq.gz -I CGT2006_2.fq.gz -o fastp_CGT2006_1.fq.gz -O fastp_CGT2006_2.fq.gz 
fastp -i CGT2010_1.fq.gz -I CGT2010_2.fq.gz -o fastp_CGT2010_1.fq.gz -O fastp_CGT2010_2.fq.gz 
fastp -i CGT2044_1.fq.gz -I CGT2044_2.fq.gz -o fastp_CGT2044_1.fq.gz -O fastp_CGT2044_2.fq.gz 
fastp -i CGT2049_1.fq.gz -I CGT2049_2.fq.gz -o fastp_CGT2049_1.fq.gz -O fastp_CGT2049_2.fq.gz  
fastp -i CGT2060_1.fq.gz -I CGT2060_2.fq.gz -o fastp_CGT2060_1.fq.gz -O fastp_CGT2060_2.fq.gz 
#script can be configured 

#Trimming
conda install -c agbiome bbtools
bbduk.sh
sudo apt install bbmap 

conda install -c bioconda trimmomatic 

trimmomatic PE -phred33 \         
 fastp_CGT2006_1.fq.gz \                                                                                                                           
 fastp_CGT2006_2.fq.gz \                                                                                                                           
 2006.r1.paired.fq.gz \                                                                                                                  
 2006.r1_unpaired.fq.gz \
 2006.r2.paired.fq.gz \
 2006.unpaired.fq.gz \
 SLIDINGWINDOW:5:35 AVGQUAL:25
 
 
trimmomatic PE -phred33 \         
 fastp_CGT2010_1.fq.gz \                                                                                                                           
 fastp_CGT2010_2.fq.gz \                                                                                                                           
 2010.r1.paired.fq.gz \                                                                                                                  
 2010.r1_unpaired.fq.gz \
 2010.r2.paired.fq.gz \
 2010.unpaired.fq.gz \
 SLIDINGWINDOW:5:35 AVGQUAL:25
 
 
trimmomatic PE -phred33 \         
 fastp_CGT2044_1.fq.gz \                                                                                                                           
 fastp_CGT2044_2.fq.gz \                                                                                                                           
 2044.r1.paired.fq.gz \                                                                                                                  
 2044.r1_unpaired.fq.gz \
 2044.r2.paired.fq.gz \
 2044.unpaired.fq.gz \
 SLIDINGWINDOW:5:35 AVGQUAL:25
 
trimmomatic PE -phred33 \         
 fastp_CGT2049_1.fq.gz \                                                                                                                           
 fastp_CGT2049_2.fq.gz \                                                                                                                           
 2049.r1.paired.fq.gz \                                                                                                                  
 2049.r1_unpaired.fq.gz \
 2049.r2.paired.fq.gz \
 2049.unpaired.fq.gz \
 SLIDINGWINDOW:5:35 AVGQUAL:25
 
 
trimmomatic PE -phred33 \         
 fastp_CGT2060_1.fq.gz \                                                                                                                           
 fastp_CGT2060_2.fq.gz \                                                                                                                           
 2060.r1.paired.fq.gz \                                                                                                                  
 2060.r1_unpaired.fq.gz \
 2060.r2.paired.fq.gz \
 2060.unpaired.fq.gz \
 SLIDINGWINDOW:5:35 AVGQUAL:25


conda install -c bioconda idba spades -y
conda install -c bioconda reapr megahit -y

#Assembly 
spades.py -1 ~/Downloads/Project_Genome_Assembly/trim3/2006.r1.paired.fq.gz -2 ~/Downloads/Project_Genome_Assembly/trim3/2006.r2.paired.fq.gz --phred-offset 33 -o ~/Downloads/Project_Genome_Assembly/asm3/2006 --threads 5
#AttributeError: module 'collections' has no attribute 'Hashable'
mkdir asm
#converting and merging fq to fa files
gzip -d 2006.r*.paired.fq.gz
fq2fa 2006.r*.paired.fq 2006.r*.paired.fa
fq2fa --merge --filter r1.paired.fa r2.paired.fa ~/Downloads/Project_Genome_Assembly/asm/2006.read.fa

gzip -d 2010.r*.paired.fq.gz
fq2fa 2010.r*.paired.fq 2010.r*.paired.fa
fq2fa --merge --filter r1.paired.fa r2.paired.fa ~/Downloads/Project_Genome_Assembly/asm/2010.read.fa

gzip -d 2044.r*.paired.fq.gz
fq2fa 2044.r*.paired.fq 2044.r*.paired.fa
fq2fa --merge --filter r1.paired.fa r2.paired.fa ~/Downloads/Project_Genome_Assembly/asm/2044.read.fa

gzip -d 2049.r*.paired.fq.gz
fq2fa 2049.r*.paired.fq 2049.r*.paired.fa
fq2fa --merge --filter r1.paired.fa r2.paired.fa ~/Downloads/Project_Genome_Assembly/asm/2049.read.fa

gzip -d 2060.r*.paired.fq.gz
fq2fa 2060.r*.paired.fq 2060.r*.paired.fa
fq2fa --merge --filter r1.paired.fa r2.paired.fa ~/Downloads/Project_Genome_Assembly/asm/2060.read.fa

idba_ud -l ~/Downloads/Project_Genome_Assembly/trim3/2006.read.fa --num_threads 2
#invalid insert distance
#Aborted(core dump)
