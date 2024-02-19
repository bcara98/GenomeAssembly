# Team2-GenomeAssembly

Final Genome Assembly Pipeline General Workflow
-----------------------------------------
FALCO -> Trimmomatic -> Megahit -> Quast

__________________________________________________________________________________

Installing the Dependencies (also mentioned in the tools_install.txt file)
-----------------------------------------
Make sure to install conda first!

Once done create a conda environment:
```
conda create -n env_name -y
```
The activate that environment
```
conda activate env_name
```
Install the next dependencies into this environment by typing the following commands
```
conda install -c bioconda falco
```
```
conda install -c bioconda megahit
```
```
conda install -c bioconda quast
```
```
conda install -c conda-forge pigz
```
```
conda install -c bioconda trimmomatic
```
__________________________________________________________________________________

The required shell scripts needed to run the pipeline are located in the **AssemblyPipeline** Folder on github.

**Do not** use any code from the Archived as those are some of the older iterations we tested.

The quality report from our assembly is located in the **quast_batch_report** folder
__________________________________________________________________________________

Important Info before running the scripts
-------------------------------------------------------------------
The **~/bin** folder **must be added** into the **$PATH** system variable located in the **.bashrc** profile file

The scripts **getfastq.sh**, **assembly_core.sh**, **batch_quast.sh** are helper scripts.
The **assembly.sh** is a wrapper script that calls those 3 helper scripts as part of the pipeline

**All shell scripts must be located inside the ~/bin folder**

To make sure that the scripts can run use the **chmod +x [excecutable]**

Once all scripts are in the **~/bin** folder type:

```
chmod +x ~/bin/[script name]
```
__________________________________________________________________________________

How to run the pipeline
-------------------------------------------------------------------
**IMPORTANT! - ONLY** run the assembly.sh script as it calls the other three in the ~/bin folder. 
```
assembly.sh -e [conda environment] -l [location of folder with the fastq files] -o [output folder] -p [optional flag-  how many pairs to assemble if not used will assemble all pairs]
```
Example how to run (-p flag is not used here so it will assemble all pairs from /home/team2/Raw_FQs):
```
assembly.sh -e env -l "/home/team2/Raw_FQs" -o "Assembly_Output"
```

Also to view a summary of the QUAST results, simply go to the **quast_batch_report** inside in the assembly output folder.
___________________________________________________________________________________

Extracting the final.contig.fa files
--------------------------------------------------------------------
To extract the final.contig.fa files for easier use after the genome assembly pipeline has ran through all the files follow the instructions bellow.

Run a separate script called **getcontigs.sh** (Also located in the FinalScriptWithComments folder). 
Make sure that the **getcontigs.sh** is also inside the ~/bin folder with ~/bin added to the $PATH variable.

**IMPORTANT!** To activate the needed conda environment properly while running the script make sure you use the **bash -i** prefix.

Here is the general syntax to run this script

```
bash -i getcontigs.sh -l [Location of Parent folder (It is the assembly pipeline output folder)] -o [Output folder that will store the gunzipped extracted fasta files] -e [Conda environment withe pigz installed]
```

Example on how to run **getcontigs.sh**

```
bash -i getcontigs.sh -l "/home/team2/results/Assembly_Output" -o "Contigs_Folder" -e env
```

The **Assembly_Output** is the folder that contains the **assembly.sh** output after the pipeline has ran through all fastq pairs.
Inside this folder you have a bunch of subfolders for each pair. The **final.contigs.fa** file it extracts is located in each of these subfolders
in the floowing file path format *Assembly_Output/Assembly_Output_SAMPLE_ID_/Assembly_Output_SAMPLE_ID__asm/final.contigs.fa*.

The **getcontigs.sh** script tries to extract a copy of all the final.contigs.fa file in this format and places them in a separate output folder in this 
example named **Contigs_Folder** gunzipped
