# Quality Check

#### Create a environment for quality control 
conda create -n qc 

conda activate qc 

conda install -c bioconda fastqc

#### Make directory to save the raw fasta files 
mkdir raw_qa

#### Run fastqc 
fastqc --threads 10 --outdir /home/pushti/raw_qa/  /home/pushti/Raw/*.fq.gz

#### Inorder to view all the quality report results in one report. Install multiqc and run it
conda install -c bioconda multiqc

cd raw_qa

multiqc .

conda deactiavte 

# Trimming Steps 
conda create -n trim 

conda activate trim 

conda install -c bioconda bbmap 

bbduk.sh # for help 

#### with avg quality = 30; 50% reads were deleted. for more reads I lowered the avg quality to 10. However I feel bbduk is not a great tool 
bbduk.sh in=/home/pushti/Raw/CGT2044_1.fq.gz in2=/home/pushti/Raw/CGT2044_2.fq.gz out=/home/pushti/trim/clean_CGT2044_1.fq.gz out2=/home/pushti/trim/clean_CGT2044_2.fq.gz stats=/home/pushti/trim/stats_CGT2044.out outs=/home/pushti/trim/singletons_CGT2044.fq.gz qtrim=w trimq=10  -da

#### I also ran trimmomatic for better results. Discarded about 8-9% of reads from each set 
trimmomatic PE -phred33 /home/pushti/Raw/CGT2044_1.fq.gz /home/pushti/Raw/CGT2044_2.fq.gz /home/pushti/trim2/2044r1.paired.fq.gz /home/pushti/trim2/2044r1.unpaired.fq.gz /home/pushti/trim2/2044r2.paired.fq.gz /home/pushti/trim2/2044r2.unpaired.fq.gz SLIDINGWINDOW:3:10 AVGQUAL:28

trimmomatic PE -phred33 /home/pushti/Raw/CGT2006_1.fq.gz /home/pushti/Raw/CGT2006_2.fq.gz /home/pushti/trim2/2006r1.paired.fq.gz /home/pushti/trim2/2006r1.unpaired.fq.gz /home/pushti/trim2/2006r2.paired.fq.gz /home/pushti/trim2/2006r2.unpaired.fq.gz SLIDINGWINDOW:3:10 AVGQUAL:28

trimmomatic PE -phred33 /home/pushti/Raw/CGT2010_1.fq.gz /home/pushti/Raw/CGT2010_2.fq.gz /home/pushti/trim2/2010r1.paired.fq.gz /home/pushti/trim2/2010r1.unpaired.fq.gz /home/pushti/trim2/2010r2.paired.fq.gz /home/pushti/trim2/2010r2.unpaired.fq.gz SLIDINGWINDOW:3:10 AVGQUAL:28

trimmomatic PE -phred33 /home/pushti/Raw/CGT2049_1.fq.gz /home/pushti/Raw/CGT2049_2.fq.gz /home/pushti/trim2/2049r1.paired.fq.gz /home/pushti/trim2/2049r1.unpaired.fq.gz /home/pushti/trim2/2049r2.paired.fq.gz /home/pushti/trim2/2049r2.unpaired.fq.gz SLIDINGWINDOW:3:10 AVGQUAL:28

trimmomatic PE -phred33 /home/pushti/Raw/CGT2060_1.fq.gz /home/pushti/Raw/CGT2060_2.fq.gz /home/pushti/trim2/2060r1.paired.fq.gz /home/pushti/trim2/2060r1.unpaired.fq.gz /home/pushti/trim2/2060r2.paired.fq.gz /home/pushti/trim2/2060r2.unpaired.fq.gz SLIDINGWINDOW:3:10 AVGQUAL:28


#### The assembler requires one input file. Merge the two files. 
reformat.sh in1=2006r1.paired.fq.gz in2=2006r2.paired.fq.gz out=2006r12.fq.gz

reformat.sh in1=2044r1.paired.fq.gz in2=2044r2.paired.fq.gz out=2044r12.fq.gz

reformat.sh in1=2060r1.paired.fq.gz in2=2060r2.paired.fq.gz out=2060r12.fq.gz

reformat.sh in1=2010r1.paired.fq.gz in2=2010r2.paired.fq.gz out=2010r12.fq.gz

reformat.sh in1=2049r1.paired.fq.gz in2=2049r2.paired.fq.gz out=2049r12.fq.gz

#### To change the file format 
conda install -c bioconda seqkit

seqkit fq2fa 2006r12.fq.gz > 2006r12.fa.gz

seqkit fq2fa 2044r12.fq.gz > 2044r12.fa.gz

seqkit fq2fa 2060r12.fq.gz > 2060r12.fa.gz

seqkit fq2fa 2010r12.fq.gz > 2010r12.fa.gz

seqkit fq2fa 2049r12.fq.gz > 2049r12.fa.gz



# Assembly 
conda create -n asm 

conda install -c bioconda idba

idba_ud -r /home/pushti/trim2/2006r12.fa.gz -o /home/pushti/asm/CGT_2006

idba_ud -r /home/pushti/trim2/2049r12.fa.gz -o /home/pushti/asm/CGT_2049

idba_ud -r /home/pushti/trim2/2060r12.fa.gz -o /home/pushti/asm/CGT_2060

idba_ud -r /home/pushti/trim2/2010r12.fa.gz -o /home/pushti/asm/CGT_2010

idba_ud -r /home/pushti/trim2/2044r12.fa.gz -o /home/pushti/asm/CGT_2044

conda deactivate 


# post assembly quality check 
conda create -n pqc

conda activate pqc 

conda install -c bioconda quast

python /home/pushti/miniconda3/envs/pqc/bin/quast /home/pushti/asm/CGT_2006/contig.fa -o /home/pushti/pqc/CGT_2006

python /home/pushti/miniconda3/envs/pqc/bin/quast /home/pushti/asm/CGT_2044/contig.fa -o /home/pushti/pqc/CGT_2044

python /home/pushti/miniconda3/envs/pqc/bin/quast /home/pushti/asm/CGT_2060/contig.fa -o /home/pushti/pqc/CGT_2060

python /home/pushti/miniconda3/envs/pqc/bin/quast /home/pushti/asm/CGT_2049/contig.fa -o /home/pushti/pqc/CGT_2049

python /home/pushti/miniconda3/envs/pqc/bin/quast /home/pushti/asm/CGT_2010/contig.fa -o /home/pushti/pqc/CGT_2010
