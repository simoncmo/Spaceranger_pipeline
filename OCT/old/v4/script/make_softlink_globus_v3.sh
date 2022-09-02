#!/bin/sh
# Make all fastq softlink in the folder
root_path="/diskmnt/primary/Spatial_Transcriptomics/data/globus/"
current_loc=$(pwd)
cd "$root_path"
all_id=$(ls -d -- */)

# Got through all folders
for id in $all_id # $@=all arguments
do 
	cd $root_path
	cd $id
	if [ $(find -type l | wc -l) -gt 0 ]; then
		echo "softlinks found in $id. Skip proceesing."
	else
		echo "Creating softlink for $id."
		awk -F, 'BEGIN {print "#!/bin/sh"} NR>1 {printf("ln -s %s %s_S1_L00%d_R%d_001.fastq.gz\n", $1, $3, $4 ,$5)}' Samplemap.csv > softlink_map.sh
		bash softlink_map.sh
		rm softlink_map.sh
		echo "Done!"
	fi
done

cd "$current_loc"
