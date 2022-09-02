#!/bin/sh
# V4. 
# Move update script to prepare_files_v*.sh
# Remove local download table. Use separate local script for this.

cd /diskmnt/primary/Spatial_Transcriptomics/spaceranger_tools/FFPE/
echo "This script turn spacranger table into scripts for spaceranger runs scripts"
SP_TABLE="table/spaceranger_table_ffpe.tsv"
SP_SCRIPT="script/out/spaceranger_scripts_ffpe.txt"

awk -F$"\t" 'NR>1 {case_id=$9; sample_id=$3; library_name=$7;
        fastq_path=$15; image_path=$16; slide=$17; area=$18; transcriptome=$13; 
        probe_set = $14; progress_status=$21;
	output_folder="/diskmnt/Datasets/Spatial_Transcriptomics/outputs_FFPE/"$9"/"$10
        if (progress_status!="Done"){
		printf("mkdir -p %s && cd %s && ", output_folder, output_folder)
                printf("spaceranger count --id=%s ",sample_id)
		printf("--sample=%s ", library_name)
                printf("--transcriptome=%s " ,transcriptome)
		printf("--probe-set=%s ", probe_set)
                printf("--fastqs=%s " ,fastq_path)
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
