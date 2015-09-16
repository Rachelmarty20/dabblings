#! /bin/csh
#$ -S /bin/csh 
#$ -o /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -e /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -cwd
#$ -l h_vmem=12G



/cellar/users/ramarty/programs/SNP2HLA_package_v1.0.3/SNP2HLA/SNP2HLA.csh /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/tcga_filtered_hwe_rs_males /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/HM_CEU_REF /cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/snp2hla/tcga_filtered_hwe_rs_males_IMPUTED /cellar/users/ramarty/programs/SNP2HLA_package_v1.0.3/SNP2HLA/plink 12000 
