# Spaceranger_pipeline
DingLab spaceranger pipeline

This is current version (Sept 2022) of Visium pipeline script.
## This script will
1. Generate FASTQ softlink file in the respective globus folder
1. Get data from tracking sheet (OCT/FFPE)
    1. OCT: https://docs.google.com/spreadsheets/d/1yeY-hHAcOFbB0CT9acUgMRSunaLkV3qr6_1aqcOMBVo/edit
    1. FFPE: https://docs.google.com/spreadsheets/d/1Sg-k6NVnyQWjhdBhbtSPjiRQcntiRVKQNGz69eCASgE/edit#gid=579866082
1. Generate spaceranger script
1. Check if image name in the folder is matching with the one in tracking sheet

## To run the script
cd into FFPE/script or OCT/script folder
```bash
bash prepare_files_v5.sh
```
Verify there's no error messages, then start a tmux session 
```bash
tmux new -a 'visium'
```
```bash
cd out
bash spaceranger_scripts_oct.txt
```



