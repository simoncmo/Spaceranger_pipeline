#!/bin/sh
# Change SP_TABLE valiable to spacernager table file name
SP_TABLE="spaceranger_table.tsv"
echo "Make image folders"
awk -F$"\t" 'NR>1 {case_name =$3; short_name=$4; sample_idx=$5;
        fastq_path=$14; image_path=$15; slide=$9; area=$10; reference_path=$12;
        fastq_status=$16; image_status=$17; progress_status=$18;
        if (fastq_status=="Yes" && progress_status!="Done"){
                printf("mkdir /diskmnt/Datasets/Spatial_Transcriptomics/images/%s\n", case_name)
        }
}' $SP_TABLE > "make_img_folder_command.sh"

bash make_img_folder_command.sh
rm make_img_folder_command.sh
echo "Folder structures created!"
