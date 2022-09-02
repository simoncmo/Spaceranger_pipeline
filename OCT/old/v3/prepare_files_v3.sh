#!/bin/sh
echo "Create softlinks"
bash make_softlink_globus_v3.sh

echo "Create Spacreranger scripts"
bash make_spaceranger_scripts_v3.sh

echo "Check if all required images uploaded."
bash check_images_v1.sh
