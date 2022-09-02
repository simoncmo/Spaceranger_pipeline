#!/bin/sh
# V4. 
# Move update script to prepare_files_v*.sh
# Remove local download table. Use separate local script for this.

echo "This script turn spacranger table into scripts for spaceranger runs scripts"
SP_TABLE="spaceranger_table.tsv"
SP_SCRIPT="spaceranger_scripts.txt"
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

# backup to log folder
current_date=$(date +'%m%d%Y')
mkdir log/$current_date/
cp $SP_SCRIPT log/$current_date/

echo "Output of current run backed up in log/$current_date"
echo "Done! Output to $SP_SCRIPT"
