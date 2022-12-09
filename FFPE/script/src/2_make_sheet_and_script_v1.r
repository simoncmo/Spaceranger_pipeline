# 9/17/2022
# 1st part: This script get sample name samplemap.csv and other info from Google sheet
# 2nd part: make script
library(tidyverse, quietly = True)
library('fuzzyjoin', quietly = True)
library(googlesheets4, quietly = True)

############################
# 1st: Make table
############################
#path
setwd('/diskmnt/primary/Spatial_Transcriptomics/Spaceranger_pipeline/FFPE/script')

# Load sheet
gs4_deauth()
ffpe = "https://docs.google.com/spreadsheets/d/1Sg-k6NVnyQWjhdBhbtSPjiRQcntiRVKQNGz69eCASgE/edit#gid=579866082"
ffpe_sheet = read_sheet(ffpe)


# Get globus ids to run
globus_ids=  ffpe_sheet %>% filter(progress_status == 'Running') %>% pull(globus_id) %>% unique

# Extract all Library Name from all samplemap.csv
col_keep = c('Library Name') 
tracking_sheet_sample_col = 'sample(from MGI Samplemap.csv, library name)'
samplemap_clean_all = map(globus_ids, function(id){
	fastq_path = str_glue('/diskmnt/primary/Spatial_Transcriptomics/data/globus/{id}')
	samplemap = read_csv(str_glue('{fastq_path}/Samplemap.csv'))
	samplemap_clean = samplemap[,col_keep, drop=F] %>% distinct %>% 
	dplyr::rename({{tracking_sheet_sample_col}} := `Library Name`)
}) %>% bind_rows()


# Select and fuzzy
tracking_sheet_library_col = 'Library Name'
sheet_select = ffpe_sheet %>% filter(progress_status == 'Running') %>% # might consider not using 'Running as filter in the future'
# Need to rething this step. Current workflow use Script to grab Library ID from trackingsheet. Might not input this in google sheet in future version?
#	filter(is.na(.data[[tracking_sheet_sample_col]])) %>% # filter row where there's no sample name
	select(-.data[[tracking_sheet_sample_col]]) %>% # remove this column to avoid conflict when merge
	dplyr::rename({{tracking_sheet_library_col}} := `Library Name`)

# fail save: 
if(nrow(sheet_select)==0) stop('No sample left to process! Check if setting progress_status = Running, and the filtering script above this line')

# Join table
by_term = c(setNames(tracking_sheet_library_col, tracking_sheet_sample_col))
joined_table = regex_inner_join(samplemap_clean_all, sheet_select, 
	by = by_term) %>% 
	select(names(ffpe_sheet)) # Reorder to match google sheet

# save
write_tsv(joined_table, 'out/updated_trackingsheet.tsv')
dir.create(str_glue('../log/{Sys.Date()}/'))
write_tsv(joined_table, str_glue('../log/{Sys.Date()}/updated_trackingsheet.tsv'))


############################
# 2nd: Make script
############################
# Ref: https://stackoverflow.com/questions/2470248/write-lines-of-text-to-a-file-in-r
scripts_out = pmap(joined_table, function(species, case_id, piece_id, `sample(from MGI Samplemap.csv, library name)`,
    `Library Name`, transcriptomome, probe_set, fastqs, image_path, slide, area,
    ...){
    output_folder = str_c("/diskmnt/Datasets/Spatial_Transcriptomics/outputs_FFPE/",species,"/",case_id,"/",piece_id)
    sample_id = `sample(from MGI Samplemap.csv, library name)`
    library_name = `Library Name`
    transcriptome = transcriptomome
    probe_set = probe_set
    fastq_path =fastqs
    image_path = image_path
    slide = slide
    area = area
    tmp = paste0(str_glue("mkdir -p {output_folder} && cd {output_folder} && "),
    str_glue("spaceranger count --id={library_name} "),
    str_glue("--sample={sample_id} "),
    str_glue("--transcriptome={transcriptome} "),
    str_glue("--probe-set={probe_set} "),
    str_glue("--fastqs={fastq_path} "),
    str_glue("--image={image_path} "),
    str_glue("--slide={slide} --area={area} "),
    "--reorient-images true ",
    "--localcores=32 ",
    "--localmem=150", collapse = "")
}) %>% unlist

# Save
out_file = 'out/spaceranger_scripts_ffpe.txt'
fileConn<-file(out_file)
writeLines(scripts_out, con = fileConn)
close(fileConn)
# Log
out_file = str_glue('../log/{Sys.Date()}/spaceranger_scripts_ffpe.txt')
fileConn<-file(out_file)
writeLines(scripts_out, con = fileConn)
close(fileConn)
message(str_glue('Script saved to {out_file}'))

############################
# 2.1 th: Echo Image vs Library pair just to make sure
############################
pwalk(joined_table, function(image, `sample(from MGI Samplemap.csv, library name)`, ...){
	print(str_glue('Image vs Library pair: {image} + {`sample(from MGI Samplemap.csv, library name)`}'))
})


############################
# 3rd: Check if file exist
############################
message('3rd: Checking if all images exist')
exist_vect = map(sheet_select$image_path, function(img_path){
	print(str_c(img_path, ": Exist? = ", file.exists(img_path)))
	return(file.exists(img_path))
}) %>% unlist
if(any(!exist_vect)){
	warning(str_glue('Totally {sum(!exist_vect)} images missing! '))
	warning('Please double check tif file name correct and matches with tracking sheet (area ID, image name etc.)')
	warning('Try ls -l /diskmnt/Datasets/Spatial_Transcriptomics/images/all/ | grep IMAGENAME')
}

