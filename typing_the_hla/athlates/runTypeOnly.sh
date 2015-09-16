#! /bin/bash
 
# Arg1 - project dir 
# Arg2 - sample id
# Arg3 - tmpdir for picard
date

source /cellar/users/ramarty/Projects/hla_new/conf/ngs.conf

mkdir ${runs_dir}/$1/$2
cp ${pcdir}/runs/$1/$2/*mapped* ${runs_dir}/$1/$2/

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
${tools_dir}/alignReads.sh $1 $2
echo "Reads aligned"

# Pull reads specific to genes of interest
for gene in $(cat ${data_dir}/genefile)
do
    ${tools_dir}/getGenes.sh $gene $1 $2
done
echo "Genes extracted"

# Run athlates to get most likely HLA allele
mkdir ${runs_dir}/$1/$2/results 2> /dev/null 
for gene in $(cat ${data_dir}/genefile)
do
    $athlates/bin/typing -bam ${runs_dir}/$1/$2/$gene.srt.bam -exlbam ${runs_dir}/$1/$2/non-$gene.srt.bam -o \
		${runs_dir}/$1/$2/results/$gene -msa ${db_dir_new}/msa/$gene\_nuc.txt
done
echo "Typing complete"

# Get coverage
for gene in $(cat ${data_dir}/genefile)
do
    ${bedtools}/coverageBed -abam ${runs_dir}/$1/$2/$gene.srt.bam -b ${db_dir_new}/bed/hla.$gene.bed \
		> ${runs_dir}/$1/$2/$gene.coverage.txt

mkdir /cellar/users/ramarty/Projects/hla_new/runs/$project/$sample
cp /data/nrnb01_nobackup/ramarty/hla/runs/$sample/results/*.typing.txt /cellar/users/ramarty/Projects/hla_new/runs/$project/$sample

done
echo "Run complete"

date
