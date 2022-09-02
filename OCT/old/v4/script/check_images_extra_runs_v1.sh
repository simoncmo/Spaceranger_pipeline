echo "This script check if all image files exist"
SP_TABLE="spaceranger_table_extra_runs.tsv"
IMG_CHECK="check_img_extra_runs.txt"

awk -F$"\t" 'NR>1 {image_path=$16; 
        fastq_status=$17; image_status=$18; progress_status=$19;

        if (fastq_status=="Yes" && progress_status!="Done"){
                printf("[ -f %s ] && echo \"%s exist.\" || echo  \"Image %s MISSING! Please check image name or re-upload.\"\n", image_path, image_path, image_path)
        }
}' $SP_TABLE > $IMG_CHECK

bash "$IMG_CHECK"
rm "$IMG_CHECK"
