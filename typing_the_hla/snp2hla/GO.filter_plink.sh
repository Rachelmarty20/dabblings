#! /bin/csh
#$ -S /bin/csh 
#$ -o /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -e /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -cwd
#$ -l h_vmem=12G




/cellar/users/hcarter/programs/plink-1.9/plink --bfile /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/tcga_filtered_hwe_rs --assoc --filter-males --make-bed --out /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/tcga_filtered_hwe_rs_males

/cellar/users/hcarter/programs/plink-1.9/plink --bfile /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/tcga_filtered_hwe_rs --assoc --filter-females --make-bed --out /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/tcga_filtered_hwe_rs_females
