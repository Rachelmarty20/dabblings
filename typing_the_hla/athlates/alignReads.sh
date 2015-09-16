#! /bin/bash

# Arg 1 project dir
# Arg 2 sample id

#source conf/ngs.conf

# Re-align reads to HLA region with NOVOALIGN
# Attempt to figure out best parameters for NOVOALIGN - see Athlates documentation for recommendations

#${NOVOALIGN}/novoalign -d ${NOVOINDEX} -f ${runs_dir}/$1/$2/fastq_for_gz	${runs_dir}/$1/$2/fastq_rev_gz -t 30 -o SAM -r all -l 70 -e 100 -i PE 135 150 | 	${samtools} view -bS -h -F 4 - > ${runs_dir}/$1/$2/novo.hlaall.bam

#${NOVOALIGN}/novoalign -d ${NOVOINDEX} -f ${runs_dir}/$1/$2/fastq_for_gz.fastq	${runs_dir}/$1/$2/fastq_rev_gz.fastq -t 30 -o SAM -r all -l 80 -e 100 -i PE 200 140 | 	${samtools} view -bS -h -F 4 - > ${runs_dir}/$1/$2/novo.hlaall.bam

${BWA}/bwa mem ${BWAINDEX} ${runs_dir}/$1/$2/fastq_for_gz.fastq	${runs_dir}/$1/$2/fastq_rev_gz.fastq | 	${samtools} view -bS -h -F 4 - > ${runs_dir}/$1/$2/bwa.hlaall.bam

# No mismatches allowed: Recommended on Athlates forum 
# For alignments that use the broad hg19, base qualities seem to be lower

# Possible alternative to NOVOALIGN
#${MOSAIK}/MosaikBuild -fr ${MOSAIKINDEX} -oa ${runs_dir}/$1/$2/mosaik.index.dat

#${MOSAIK}/MosaikBuild -q ${runs_dir}/$1/$2/fastq_for_gz -q2 ${runs_dir}/$1/$2/fastq_rev_gz -out ${runs_dir}/$1/$2/mosaik.hlaall.build.dat -st illumina -mfl 135

#${MOSAIK}/MosaikAligner -in ${runs_dir}/$1/$2/mosaik.hlaall.build.dat -out ${runs_dir}/$1/$2/mosaik.hlaall.aligned.dat -ia ${runs_dir}/$1/$2/mosaik.index.dat -annpe ${MOSAIKNET}/2.1.78.pe.ann -annse ${MOSAIKNET}/2.1.78.se.ann -minp 0.4 -p 10 -mms -3 -ms 1 -hgop 4 -gop 5 -gep 2 -m all -bw 29 -a all -act 20 -mm 0

#${MOSAIK}/MosaikText -in ${runs_dir}/$1/$2/mosaik.hlaall.aligned.dat -bam ${runs_dir}/$1/$2/mosaik.hlall.bam

# Sort new alignment
#${samtools} view -u ${runs_dir}/$1/$2/novo.hlaall.bam | ${samtools} sort -n -m 3000000000 - ${runs_dir}/$1/$2/novo.hlaall.srt 2> /dev/null
#${samtools} view -u ${runs_dir}/$1/$2/mosaik.hlaall.bam | ${samtools} sort -n -m 3000000000 - ${runs_dir}/$1/$2/mosaik.hlaall.srt 2> /dev/null
${samtools} view -u ${runs_dir}/$1/$2/bwa.hlaall.bam | ${samtools} sort -n -m 3000000000 - ${runs_dir}/$1/$2/bwa.hlaall.srt 2> /dev/null


# Index and get stats
#${samtools} index ${runs_dir}/$1/$2/novo.hlaall.srt.bam
#${samtools} index ${runs_dir}/$1/$2/mosaik.hlaall.srt.bam
${samtools} index ${runs_dir}/$1/$2/bwa.hlaall.srt.bam


${bamtools} stats \
  -insert \
  -in ${runs_dir}/$1/$2/bwa.hlaall.srt.bam \
  > ${runs_dir}/$1/$2/bwa.hlaall.srt.stats


rm ${runs_dir}/$1/$2/fastq_for_gz.fastq
rm ${runs_dir}/$1/$2/fastq_rev_gz.fastq
rm ${runs_dir}/$1/$2/bwa.hlaall.bam



