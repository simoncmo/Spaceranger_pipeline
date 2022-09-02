#!/bin/sh
# Change SP_TABLE valiable to spacernager table file name
# Change SP_SCRIPT to spacernager script file name
# Change SP_DOWNLOAD to local downloading script file name
echo "Update table from Google sheet.."
bash update_table.sh

echo "This script turn spacranger table into scripts for spaceranger runs scripts"
SP_TABLE="spaceranger_table.tsv"
SP_SCRIPT="spaceranger_scripts.txt"
SP_DOWNLOAD="local_download_scripts.txt"
awk -F$"\t" 'NR>1 {case_name=$3; short_name=$4; sample_idx=$5;
        fastq_path=$14; image_path=$15; slide=$9; area=$10; reference_path=$12; 
        fastq_status=$16; image_status=$17; progress_status=$18;
	output_folder="/diskmnt/Datasets/Spatial_Transcriptomics/outputs/"$3
        if (fastq_status=="Yes" && progress_status!="Done"){
		printf("mkdir -p %s && cd %s && ", output_folder, output_folder)
                printf("spaceranger count --id=%s ",short_name)
                printf("--transcriptome=%s " ,reference_path)
                printf("--fastqs=%s " ,fastq_path)
                printf("--sample=%s ", sample_idx)
                printf("--image=%s ", image_path)
                printf("--slide=%s --area=%s ", slide, area)
                printf("--reorient-images ")
                printf("--localcores=32 ")
                printf("--localmem=150\n")
        }
}' $SP_TABLE > $SP_SCRIPT

# Copy to local
awk -F$"\t" 'NR>1 {case_name =$3; short_name=$4;
	fastq_status=$16; progress_status=$18;
        folder_path="~/Box/Ding_Lab/Projects_Current/Spatial_transcriptomics/processed_data/"case_name"/"short_name
        if (fastq_status=="Yes" && progress_status!="Done"){
		print("# This is for sample: ", short_name)
        	print("mkdir -p", folder_path)
        	print("cd", folder_path)
        	printf("rsync -av -e ssh --exclude=\"*.bam*\" katmai:/diskmnt/Datasets/Spatial_Transcriptomics/outputs/%s/%s/outs . \n\n", case_name, short_name)
	}
}' $SP_TABLE > $SP_DOWNLOAD

# backup to log folder
current_date=$(date +'%m%d%Y')
mkdir log/$current_date/
cp $SP_DOWNLOAD log/$current_date/
cp $SP_SCRIPT log/$current_date/

echo "Output of current run backed up in log/$current_date"
echo "Done! Output to $SP_SCRIPT and $SP_DOWNLOAD"
