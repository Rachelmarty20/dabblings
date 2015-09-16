#! /bin/csh
#$ -S /bin/csh
#$ -o /data/nrnb01_nobackup/ramarty/sge-system-files
#$ -e /data/nrnb01_nobackup/ramarty/sge-system-files
#$ -cwd
#$ -t 1-4
#$ -l h_rt=08:00:00,h_vmem=1G
#$ -l long
#$ -p -11

set mutations=(R132L R132H R132C R132G R132S)
set genes=(IDH1 IDH1 IDH1 IDH1 IDH1)
set hlas=(HLA-A HLA-A HLA-A HLA-A HLA-A)
set nums=(01:01 01:01 01:01 01:01 01:01)

set mutation=$mutations[$SGE_TASK_ID]
set gene=$genes[$SGE_TASK_ID]
set hla=$hlas[$SGE_TASK_ID]
set num=$nums[$SGE_TASK_ID]


date
hostname
mkdir /data/nrnb01/ramarty/hla/affinities_mut_15_08_21/$gene\_$mutation
/cellar/users/ramarty/programs/mhc_i/src/predict_binding.py IEDB_recommended $hla"*"$num 10 /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/mutated.2015-08-19/$gene\_$mutation.fsa > /data/nrnb01/ramarty/hla/affinities_mut_15_08_21/$gene\_$mutation/$hla"*"$num.affinities
date