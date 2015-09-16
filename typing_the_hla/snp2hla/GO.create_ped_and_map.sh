#! /bin/csh
#$ -S /bin/csh 
#$ -o /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -e /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -cwd
#$ -l h_vmem=12G


/cellar/users/hcarter/programs/plink-1.9/plink --bfile tcga_filtered_hwe --recode --out tcga_filtered_hwe
