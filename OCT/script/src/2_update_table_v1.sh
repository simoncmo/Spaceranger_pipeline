#cd /diskmnt/primary/Spatial_Transcriptomics/spaceranger_tools/OCT/
cd '../'
mkdir table
wget --no-check-certificate -O table/spaceranger_table_oct.tsv 'https://docs.google.com/spreadsheets/d/1yeY-hHAcOFbB0CT9acUgMRSunaLkV3qr6_1aqcOMBVo/export?format=tsv&gid=579866082'
echo "spaceranger_table_oct.tsv updated from Google Sheet"
