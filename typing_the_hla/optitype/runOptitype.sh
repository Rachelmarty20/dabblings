#! /bin/bash
 
# Arg1 - project dir 
# Arg2 - sample id
# Arg3 - temp dir
date

source /cellar/users/ramarty/Projects/hla_new/conf/optitype.conf
echo "Imported sources"

mkdir ${work_dir}/$1/$2
cp ${in_dir}/$1/$2/*mapped* ${work_dir}/$1/$2/
echo "Copied files into work directory"

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
${razers3} --percent-identity 90 --max-hits 1 --distance-range 0 --output ${work_dir}/$1/$2/rev_fished.sam ${optitype}/data/hla_reference_dna.fasta ${work_dir}/$1/$2/fastq_rev_gz.fastq
${razers3} --percent-identity 90 --max-hits 1 --distance-range 0 --output ${work_dir}/$1/$2/for_fished.sam ${optitype}/data/hla_reference_dna.fasta ${work_dir}/$1/$2/fastq_for_gz.fastq
echo "Aligned to hla alleles"

# Strip reads
cat ${work_dir}/$1/$2/rev_fished.sam | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > ${work_dir}/$1/$2/rev_fished.fastq
cat ${work_dir}/$1/$2/for_fished.sam | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > ${work_dir}/$1/$2/for_fished.fastq
echo "Reads stripped"

# Type hla region
cd /cellar/users/ramarty/programs/OptiType 
python OptiTypePipeline.py -i ${work_dir}/$1/$2/for_fished.fastq ${work_dir}/$1/$2/rev_fished.fastq --dna --o ${out_dir}/$1/$2 -v
echo "Typed the hla region"

# Delete all extraneous files


echo "Run complete"

date

