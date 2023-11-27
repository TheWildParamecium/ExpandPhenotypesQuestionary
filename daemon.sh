#! /usr/bin/env bash

preset=1 #it can be 1 (default) or 2 (JA mode)
max_targets_hpo=70
base_dir=`pwd`
data_dir=$base_dir/input_data


echo "1. Running LSYNGAP1_initial_phenotypes"
echo -e  "id\t`cut -f 1 $data_dir/SYNGAP1_initial_phenotypes.txt | tr "\n" "|" `" | sed 's/|$//g' > $data_dir/disease_profile
./get_suggestions.sh $data_dir/SYNGAP1_initial_phenotypes.txt $max_targets_hpo $preset $data_dir/black_list_syngap1.txt comorbidity_suggestions_first_round
./run_cohort_analyzer.sh $data_dir/disease_profile $base_dir/SYNGAP1_initial_phenotypes

echo "2. Running SYNGAP1_secondround_phenotypes"
echo -e  "id\t`cut -f 1 $data_dir/SYNGAP1_secondround_phenotypes.txt | tr "\n" "|" `" | sed 's/|$//g' > $data_dir/disease_profile_second
./get_suggestions.sh $data_dir/SYNGAP1_secondround_phenotypes.txt $max_targets_hpo $preset $data_dir/black_list_syngap2.txt comorbidity_suggestions_second_round
./run_cohort_analyzer.sh $data_dir/disease_profile_second $base_dir/SYNGAP1_secondround_phenotypes

echo "3. Running third round NSEeuronet"
echo -e  "id\t`cut -f 1 $data_dir/questionaire_HPs.txt | tr "\n" "|" `" | sed 's/|$//g' > $data_dir/disease_profile_third
./get_suggestions.sh $data_dir/questionaire_HPs.txt $max_targets_hpo $preset $data_dir/black_list_syngap3.txt comorbidity_suggestions_third_round
./run_cohort_analyzer.sh $data_dir/disease_profile_third $base_dir/questionaire_HPs