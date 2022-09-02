#!/bin/sh

# Initiate conda environment and run scripts
# conda activate spatial_trans

# backup to log folder
current_date=$(date +'%m%d%Y')
time parallel -j+0 --progress < spaceranger_scripts_extra_runs.txt > log/$current_date/run_"$current_date"._extra_runslog
