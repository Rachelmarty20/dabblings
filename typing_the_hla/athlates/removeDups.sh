#! /bin/bash

# Arg 1 = project dir
# Arg 2 = sample id
# Arg 3 = tmpdirnmae
#source conf/ngs.conf


mkdir -p ${tmp_folder}/$3

# If BWA Mem is not playing well with picard, may need to remove "null" mappings to get MarkDuplicates to run
#${samtools} view -h ${output_dir}/${subjectID}.fxmt.flt.clean.bam | grep -v "null" | samtools view -bS - > ${output_dir}/${subjectID}.fxmt.flt.clean2.bam

# Mark PCR duplicates
#${java} -Xmx${heap}m -Djava.io.tmpdir\=${tmp_folder}/$3 \
${java} -Xmx${heap}m  \
 -jar ${picard}/MarkDuplicates.jar \
 I\=${runs_dir}/$1/$2/hlaall.srt.bam \
 O\=${runs_dir}/$1/$2/hlaall.cleaned.bam \
 M\=${runs_dir}/$1/$2/hlaall.duplicate_report.txt \
 VALIDATION_STRINGENCY\=SILENT \
 REMOVE_DUPLICATES\=false

# Index marked bam file
${samtools} index ${runs_dir}/$1/$2/hlaall.cleaned.bam

# Get summary statistics
${bamtools} stats \
  -insert \
  -in ${runs_dir}/$1/$2/hlaall.cleaned.bam \
  > ${runs_dir}/$1/$2/hlaall.cleaned.stats

rm -rf ${tmp_folder}/$3
