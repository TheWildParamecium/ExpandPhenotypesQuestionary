#! /usr/bin/env bash

. ~soft_bio_267/initializes/init_python

hpo=$(semtools -d list | grep HPO)

current_folder=`pwd`
sample=`basename $1 .txt`
sample_folder=$current_folder/$sample
template_folder=$current_folder/templates
tpm_folder=$sample_folder/tpm
deleted_terms_folder=$sample_folder/deleted_terms
output_data_folder=$sample_folder/output_data
output_htmls_folder=$sample_folder/suggestions_report
relations_file=/mnt/home/users/bio_267_uma/jperezg/useful_data/MERGED2MONDO_cleaned_reliable_pairs

mkdir -p $sample_folder; mkdir -p $tpm_folder; mkdir -p $deleted_terms_folder; mkdir -p $output_data_folder; mkdir -p $output_htmls_folder;
if [ ! -d $sample_folder/output_data ]; then mkdir -p $sample_folder/output_htmls; mkdir -p $sample_folder/output_data; fi;
if [ ! -f $sample_folder/query_phenotypes.txt ]; then cut -f 1 $1 > $sample_folder/query_phenotypes.txt; fi;

cp $4 $tpm_folder/black_list_hp_codes_and_names.txt
cut -f 1 $4 > $tpm_folder/black_list_hp_codes.txt

#Wether to use hypergeometric (1) or p-values (2) 
if [ $3 -eq 1 ]; then
	tranformation="no"
elif [ $3 -eq 2 ]; then
	tranformation="exp"
fi

echo "Running first step"
get_sorted_suggestions -q $sample_folder/query_phenotypes.txt \
						  -r $relations_file \
						  -b $tpm_folder/black_list_hp_codes.txt \
						  --max_targets $2 \
						  -O $hpo \
						  -o $output_data_folder/suggestions_1.txt \
						  -d $deleted_terms_folder \
						  -t nc -T $tranformation

echo "Running second step"
get_sorted_suggestions -q $sample_folder/query_phenotypes.txt \
						  -r $relations_file \
						  -b $tpm_folder/black_list_hp_codes.txt \
						  --max_targets $2 \
						  -O $hpo \
						  -o $output_data_folder/suggestions_2.txt \
						  -d $deleted_terms_folder \
						  -t nc -f -T $tranformation

echo "Running third step"					  
get_sorted_suggestions -q $sample_folder/query_phenotypes.txt \
						  -r $relations_file \
						  -b $tpm_folder/black_list_hp_codes.txt \
						  --max_targets $2 \
						  -O $hpo \
						  -o $output_data_folder/suggestions_3.txt \
						  -d $deleted_terms_folder \
						  -t nc -f -c -T $tranformation

datapaths=`echo -e "
$output_data_folder/suggestions_1.txt,
$output_data_folder/suggestions_2.txt,
$output_data_folder/suggestions_3.txt,
$deleted_terms_folder/suggestions_1_deleted_empty_query_hpos.txt,
$deleted_terms_folder/suggestions_2_deleted_empty_query_hpos.txt,
$deleted_terms_folder/suggestions_3_deleted_empty_query_hpos.txt,
$deleted_terms_folder/suggestions_1_deleted_query_self_parentals.txt,
$deleted_terms_folder/suggestions_2_deleted_query_self_parentals.txt,
$deleted_terms_folder/suggestions_3_deleted_query_self_parentals.txt,
$deleted_terms_folder/suggestions_1_deleted_query_parental_targets.txt,
$deleted_terms_folder/suggestions_2_deleted_query_parental_targets.txt,
$deleted_terms_folder/suggestions_3_deleted_query_parental_targets.txt,
$tpm_folder/black_list_hp_codes_and_names.txt,
$output_data_folder/targets_number_of_hits.txt
" | tr -d [:space:]`

if [ $3 -eq 1 ]; then
	report_html -t $template_folder/sugestions_preset1.txt \
					-d $datapaths \
					-o $output_htmls_folder/$5		
elif [ $3 -eq 2 ]; then
	report_html -t $template_folder/sugestions_preset2.txt \
					-d $datapaths \
					-o $output_htmls_folder/$5
fi
