Spaceranger run prep
Will read from Google sheet automatically

Run copy_tif_to_katmai.sh in local to copy images from Siqi's result folder to katmai
~/Box/Ding_Lab/Projects_Current/Spatial_transcriptomics/Analysis/Simon/spaceranger_scripts/copy_tif_to_katmai.sh

First: Run prepare_files_v3.sh
- 1. create softlinks for fastq
- 2. Update from google sheet
- 3. update sample table from Google sheet
- 4. make spaceranger script file 
Check if output successfully.

Second: Run conda activate spatial_trans

Thrid: Run run_spaceranger_parallel_v3.sh to start parallel of all tasks in the cluster 
