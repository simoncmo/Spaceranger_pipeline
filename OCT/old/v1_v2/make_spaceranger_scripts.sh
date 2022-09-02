#!/bin/sh
# Change SP_TABLE valiable to spacernager table file name
# Change SP_SCRIPT to spacernager script file name
# Change SP_DOWNLOAD to local downloading script file name
echo "This script turn spacranger table into scripts for spaceranger runs"
echo "Default file names: spaceranger_table.tsv, spaceranger_scripts.txt and local_download_scripts.txt"
echo "Edit the variables in this script to change that."
SP_TABLE="spaceranger_table.tsv"
SP_SCRIPT="spaceranger_scripts.txt"
SP_DOWNLOAD="local_download_scripts.txt"
awk -F$"\t" 'NR>1 {case_name =$3; short_name=$4; sample_idx=$5;
	fastq_path=$14; image_path=$15; slide=$9; area=$10; reference_path=$12
	print("# This is for sample: ", short_name)
	print("conda activate spatial_trans")
	printf("mkdir /diskmnt/Datasets/Spatial_Transcriptomics/outputs/%s\n", case_name)
	printf("cd /diskmnt/Datasets/Spatial_Transcriptomics/outputs/%s\n", case_name)
	printf("spaceranger count --id=%s \\\n",short_name)
	printf("--transcriptome=%s \\\n" ,reference_path)
	printf("--fastqs=%s \\\n" ,fastq_path)
	printf("--sample=%s \\\n", sample_idx)
	printf("--image=%s \\\n", image_path)
	printf("--slide=%s --area=%s \\\n", slide, area)
	print("--reorient-images \\")
	print("--localcores=32 \\")
	print("--localmem=150\n")
}' $SP_TABLE > $SP_SCRIPT

# Copy to local
awk -F$"\t" 'NR>1 {case_name =$3; short_name=$4; 
	folder_path="~/Box/Ding_Lab/Projects_Current/Spatial_transcriptomics/processed_data/"case_name"/"short_name
	print("# This is for sample: ", short_name)
	print("mkdir -p", folder_path)
	print("cd", folder_path)
	printf("rsync -av -e ssh --exclude='*.bam*' katmai:/diskmnt/Datasets/Spatial_Transcriptomics/outputs/%s/%s/outs . \n\n", case_name, short_name)
	
}' $SP_TABLE > $SP_DOWNLOAD
