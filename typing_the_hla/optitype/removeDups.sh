#! /bin/bash

# Arg 1 = project dir
# Arg 2 = sample id
# Arg 3 = tmp dir name


mkdir -p ${tmp_dir}/$3

# Mark PCR duplicates
#${java} -Xmx${heap}m -Djava.io.tmpdir\=${tmp_dir}/$3 \
${java} -Xmx${heap}m  \
 -jar ${picard}/MarkDuplicates.jar \
 I\=${work_dir}/$1/$2/hlaall.srt.bam \
 O\=${work_dir}/$1/$2/hlaall.cleaned.bam \
 M\=${work_dir}/$1/$2/hlaall.duplicate_report.txt \
 VALIDATION_STRINGENCY\=SILENT \
 REMOVE_DUPLICATES\=false

# Index marked bam file
${samtools} index ${work_dir}/$1/$2/hlaall.cleaned.bam

# Get summary statistics
${bamtools} stats \
  -insert \
  -in ${work_dir}/$1/$2/hlaall.cleaned.bam \
  > ${work_dir}/$1/$2/hlaall.cleaned.stats

rm -rf ${tmp_dir}/$3
