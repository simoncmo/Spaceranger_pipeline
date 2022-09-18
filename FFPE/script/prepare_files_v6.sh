# 9/17/2022 new version. use R to grab info 
#!/bin/sh
echo "Pipeline to create links for FFPE files"
echo "1. Create softlinks"
bash src/1_make_softlink_globus_v3.sh

echo "2 Update MGI download info, Extra runs sheet from Google sheet.."
echo "AND 3. Create Spacreranger scripts"

eval "$(conda shell.bash hook)"
env_name="/diskmnt/Projects/Users/simonmo/Softwares/miniconda3/envs/Signac"
conda activate $env_name
echo "Make sure $env_name is activate"
which Rscript
Rscript src/2_make_sheet_and_script_v1.r

#echo "4. Check if all required images uploaded."
#bash src/4_check_images_v1.sh
