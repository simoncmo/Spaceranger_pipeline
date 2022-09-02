#!/bin/sh
echo "1. Create softlinks"
bash make_softlink_globus_v3.sh

echo "2 Update MGI download info, Extra runs sheet from Google sheet.."
bash update_table_v1.sh
bash update_table_extra_runs_v1.sh

echo "3. Create Spacreranger scripts"
bash make_spaceranger_scripts_v4.sh
bash make_spaceranger_scripts_extra_runs_v4.sh

echo "4. Check if all required images uploaded."
bash check_images_v1.sh
bash check_images_extra_runs_v1.sh
