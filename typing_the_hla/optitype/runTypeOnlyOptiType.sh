#! /bin/bash
 
# Arg1 - project dir 
# Arg2 - sample id
# Arg3 - tmpdir for picard
date
source conf/ngs.conf

# Merge Bam file
${tools_dir}/mergeBams.sh $1 $2
echo "Bam files merged"

# Remove PCR duplicates
${tools_dir}/removeDups.sh $1 $2 $3
echo "PCR Duplicates marked" 

# Strip reads
${tools_dir}/bam2fastq.sh $1 $2 $3
echo "Reads stripped"

# Align to hla alleles
#${tools_dir}/alignReadsRazers.sh $1 $2
#echo "Reads aligned"

# Run OptiType to get most likely HLA allele
#python ${optitype}/OptiTypePipeline.py -i opti.hlaall.forw.fastq opti.hlaall.rev.fastq \
#                    --dna --enumerate ENUMERATE  \
#                    --o ${runs_dir}/$1/$2/opti_results/

# Run Optitype without razers
python ${optitype}/OptiTypePipeline.py -i fastq_rev_gz.fastq fastq_for_gz.fastq \
                    --dna --enumerate ENUMERATE \
                    --o ${runs_dir}/$1/$2/opti_results/
echo "Typing complete"

cp -R /oasis/ramarty/runs/$project/$sample/opti_results /cellar/users/ramarty/Projects/hla/runs/$project/$sample/
cp /oasis/ramarty/runs/$project/$sample/opti.hlaall.srt.stats /cellar/users/ramarty/Projects/hla/runs/$project/$sample/
date
