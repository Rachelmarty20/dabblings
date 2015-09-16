#! /bin/bash

# Arg 1: Gene ID
# Arg 2: Project Dir
# Arg 3: Sample ID
#source conf/ngs.conf

# Pull reads that map to the HLA gene of interest
#${samtools} view -b -L ${db_dir}/bed/hla.$1.bed -o ${runs_dir}/$2/$3/$1.bam ${runs_dir}/$2/$3/novo.hlaall.srt.bam 
${samtools} view -b -L ${db_dir}/bed/hla.$1.bed -o ${runs_dir}/$2/$3/$1.bam ${runs_dir}/$2/$3/bwa.hlaall.srt.bam
${samtools} view -H -o ${runs_dir}/$2/$3/$1.sam.header ${runs_dir}/$2/$3/$1.bam
${samtools} view -o ${runs_dir}/$2/$3/$1.sam ${runs_dir}/$2/$3/$1.bam
sort -k 1,1 -k 3,3 ${runs_dir}/$2/$3/$1.sam > ${runs_dir}/$2/$3/$1.srt.sam
cat ${runs_dir}/$2/$3/$1.sam.header ${runs_dir}/$2/$3/$1.srt.sam > ${runs_dir}/$2/$3/$1.sam
${samtools} view -bS -o ${runs_dir}/$2/$3/$1.srt.bam ${runs_dir}/$2/$3/$1.sam

echo ${samtools} index ${runs_dir}/$2/$3/$1.srt.bam
${samtools} index ${runs_dir}/$2/$3/$1.srt.bam

# Get summary statistics for reads on a per gene basis
${bamtools} stats \
  -insert \
  -in ${runs_dir}/$2/$3/$1.srt.bam \
  > ${runs_dir}/$2/$3/$1.stats

# Now pull reads that map to all the other HLA genes
${samtools} view -b -L ${db_dir}/bed/hla.non-$1.bed -o ${runs_dir}/$2/$3/non-$1.bam ${runs_dir}/$2/$3/bwa.hlaall.srt.bam
#${samtools} view -b -L ${db_dir}/bed/hla.non-$1.bed -o ${runs_dir}/$2/$3/non-$1.bam ${runs_dir}/$2/$3/novo.hlaall.srt.bam
${samtools} view -H -o ${runs_dir}/$2/$3/non-$1.sam.header ${runs_dir}/$2/$3/non-$1.bam
${samtools} view -o ${runs_dir}/$2/$3/non-$1.sam ${runs_dir}/$2/$3/non-$1.bam
sort -k 1,1 -k 3,3 ${runs_dir}/$2/$3/non-$1.sam > ${runs_dir}/$2/$3/non-$1.srt.sam
cat ${runs_dir}/$2/$3/non-$1.sam.header ${runs_dir}/$2/$3/non-$1.srt.sam > ${runs_dir}/$2/$3/non-$1.sam
${samtools} view -bS -o ${runs_dir}/$2/$3/non-$1.srt.bam ${runs_dir}/$2/$3/non-$1.sam

${samtools} index ${runs_dir}/$2/$3/non-$1.srt.bam

# Get summary statistics 
${bamtools} stats \
  -insert \
  -in ${runs_dir}/$2/$3/non-$1.srt.bam \
  > ${runs_dir}/$2/$3/non-$1.stats 

rm ${runs_dir}/$2/$3/$1.sam
rm ${runs_dir}/$2/$3/non-$1.sam
rm ${runs_dir}/$2/$3/$1.bam
rm ${runs_dir}/$2/$3/non-$1.bam
rm ${runs_dir}/$2/$3/$1.srt.sam
rm ${runs_dir}/$2/$3/non-$1.srt.sam


