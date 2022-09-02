echo "This script check if all image files exist"
SP_TABLE="spaceranger_table.tsv"
IMG_CHECK="check_img.txt"

awk -F$"\t" 'NR>1 {image_path=$15; 
        fastq_status=$16; image_status=$17; progress_status=$18;

        if (fastq_status=="Yes" && progress_status!="Done"){
                printf("[ -f %s ] && echo \"%s exist.\" || echo  \"Image %s MISSING! Please check image name or re-upload.\"\n", image_path, image_path, image_path)
        }
}' $SP_TABLE > $IMG_CHECK

bash "$IMG_CHECK"
rm "$IMG_CHECK"
