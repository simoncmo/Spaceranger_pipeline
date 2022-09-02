root_path="/diskmnt/primary/Spatial_Transcriptomics/data/globus/"
for id in "$@" # $@=all arguments
do 
	echo "Making fastq softlinks for $id folder";
	cd $root_path
	cd $id
	awk -F, 'BEGIN {print "#!/bin/sh"} NR>1 {printf("ln -s %s %s_S1_L00%d_R%d_001.fastq.gz\n", $1, $3, $4 ,$5)}' Samplemap.csv > softlink_map.sh
	bash softlink_map.sh
	rm softlink_map.sh
done

