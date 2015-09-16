#! /bin/csh
#$ -S /bin/csh
#$ -o /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -e /data/nrnb01_nobackup/ramarty/hla/sge-system-files
#$ -cwd
#$ -l h_vmem=12G


python /cellar/users/ramarty/programs/OptiType/OptiTypePipeline.py -i ./test/rna/CRC_81_N_2_fished.fastq ./test/rna/CRC_81_N_2_fished.fastq -r -v -o ./test/rna/
