#! /bin/bash

# Arg 1 project dir
# Arg 2 sample id

echo "Merging bamfiles ..."

# Merge mapped.bam, unmapped1.bam, unmapped2.bam and unmapped3.bam into a file called hlaall.bam
rm ${runs_dir}/$1/$2/hlaall.bam
echo "Bam removed ..."
#${samtools} merge ${runs_dir}/$1/$2/hlaall.bam ${runs_dir}/$1/$2/mapped.bam ${runs_dir}/$1/$2/unmapped.bam

${samtools} merge ${runs_dir}/$1/$2/hlaall.bam ${runs_dir}/$1/$2/mapped.bam ${runs_dir}/$1/$2/unmapped1.bam ${runs_dir}/$1/$2/unmapped2.bam ${runs_dir}/$1/$2/unmapped3.bam

echo "Bams Merged, no stats yet ..."

# Get read statistics post merge
${bamtools} stats \
  -insert \
  -in ${runs_dir}/$1/$2/hlaall.bam \
  > ${runs_dir}/$1/$2/hlaall.stats

echo "Bams Merged. Sorting ..."

# Sort into coordinate order
${samtools} view -u ${runs_dir}/$1/$2/hlaall.bam | ${samtools} \
	sort -m 3000000000 - ${runs_dir}/$1/$2/hlaall.srt

# Index and get stats on sorted file (should be the same as pre-sort)
${samtools} index ${runs_dir}/$1/$2/hlaall.srt.bam

${bamtools} stats \
  -insert \
  -in ${runs_dir}/$1/$2/hlaall.srt.bam \
  > ${runs_dir}/$1/$2/hlaall.srt.stats




