#!/bin/sh
# V4. 
# Move update script to prepare_files_v*.sh
# Remove local download table. Use separate local script for this.
# This is for Extra_runs table

echo "This script turn spacranger Extra_runs table into scripts for spaceranger runs scripts"
SP_TABLE="spaceranger_table_extra_runs.tsv"
SP_SCRIPT="spaceranger_scripts_extra_runs.txt"
awk -F$"\t" 'NR>1 {extra_run_type=$1; case_name=$4; short_name=$5; sample_idx=$6;
        fastq_path=$15; image_path=$16; slide=$10; area=$11; reference_path=$13; 
        fastq_status=$17; image_status=$18; progress_status=$19;
	output_folder="/diskmnt/Datasets/Spatial_Transcriptomics/outputs/"$4"/"$1
        if (fastq_status=="Yes" && progress_status!="Done"){
		printf("mkdir -p %s && cd %s && ", output_folder, output_folder)
                printf("spaceranger count --id=%s_%s ",extra_run_type, short_name)
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
