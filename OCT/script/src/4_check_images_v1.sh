echo "This script check if all image files exist"
echo "If no MISSING message means everything correct!"
#cd /diskmnt/primary/Spatial_Transcriptomics/spaceranger_tools/OCT/
cd '../'
SP_TABLE="table/spaceranger_table_oct.tsv"
IMG_CHECK="check_img.txt"

awk -F$"\t" 'NR>1 {image_path=$16; progress_status=$21;

        if (progress_status=="Running"){
                printf("[ -f %s ] && echo \"%s exist.\" || echo  \"Image %s MISSING! Please check image name or re-upload.\"\n", image_path, image_path, image_path)
        }
}' $SP_TABLE > $IMG_CHECK

bash "$IMG_CHECK"
rm "$IMG_CHECK"
