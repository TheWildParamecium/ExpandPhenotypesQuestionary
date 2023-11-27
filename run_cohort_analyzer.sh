#!/usr/bin/env bash
hostname
. ~soft_bio_267/initializes/init_python

export ic_file=~elenarojano/projects/decipher/autocipher/decipher_data/processed_data/uniq_hpo_with_CI.txt
output_dir=$2/cohort_analyzer_reports
output_filename=`basename $1 .txt`

mkdir -p $output_dir
echo "Running cohort analyzer"
cohort_analyzer -i $1 -o $output_dir/$output_filename -H -p 1 -d 0 -C 6  -f 2 -t freq -D -m lin -a