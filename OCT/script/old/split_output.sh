## THis script split output to 2 files
echo "THis script split output to 2 files"
NSAMPLE=$(( $(wc -l < out/spaceranger_scripts_oct.txt) ))

cd out/
csplit -sf run. spaceranger_scripts_oct.txt $(( $NSAMPLE / 2 + 1)) 
