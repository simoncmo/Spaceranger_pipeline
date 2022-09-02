#!/bin/sh
echo "Pipeline to create links for OCT files"
echo "1. Create softlinks"
bash src/1_make_softlink_globus_v3.sh

echo "2 Update MGI download info, Extra runs sheet from Google sheet.."
bash src/2_update_table_v1.sh

echo "3. Create Spacreranger scripts"
bash src/3_make_spaceranger_scripts_v5.sh

echo "4. Check if all required images uploaded."
bash src/4_check_images_v1.sh
