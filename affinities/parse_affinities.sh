#! /bin/bash

#rm ../mhcafffile
rm ../mhcaff_complete.txt
for file in $(cat $1)
do
    #./old.parse_affinity $file ~/programs/mhc_i/human_MHC_alleles_uniq.txt min >> ../mhcafffile
    ./parse_affinity $file ~/programs/mhc_i/human_MHC_alleles_uniq.txt all >> ../mhcaff_complete.txt
done