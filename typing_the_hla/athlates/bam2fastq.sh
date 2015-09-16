#! /bin/bash
#source conf/ngs.conf

# Arg 1 Project Dir
# Arg 2 Sample ID
# Arg 3 tmpdir for picard

mkdir ${tmp_folder}/$3

# Update read information
# NOTE: THIS SUDDENLY STARTED CRASHING WITH A COMPLAINT ABOUT INCORRECT BIN - CAN GET AROUND IT WITH "VALIDSTION-STRINGENCY=LENIENT" 
#${java} -Xmx${heap}m -Djava.io.tmpdir\=${tmp_folder}/$3 -jar ${picard}/FixMateInformation.jar I=${runs_dir}/$1/$2/hlaall.cleaned.bam O=${runs_dir}/$1/$2/hlaall.fixed.bam VALIDATION_STRINGENCY=LENIENT
${java} -Xmx${heap}m  -jar ${picard}/FixMateInformation.jar I=${runs_dir}/$1/$2/hlaall.cleaned.bam O=${runs_dir}/$1/$2/hlaall.fixed.bam VALIDATION_STRINGENCY=LENIENT

# Coordinate sort
# Work around to manually correct read names for Picard SamToFastq
# NOTE: samtools sort -o -n infile outprefix  => If outprefix is not distinct, there can be problems
${samtools} sort -o -n ${runs_dir}/$1/$2/hlaall.fixed.bam $1\_$2 | ${samtools} view - | ${tools_dir}/resolvepairs > ${runs_dir}/$1/$2/hlaall.forfastq 2> /dev/null

# Strip reads and encode in fastq format (htslib is a possible alternative to PICARD)
#${java} -Xmx${heap}m -Djava.io.tmpdir\=${tmp_folder}/$3 -jar ${picard}/SamToFastq.jar I=${runs_dir}/$1/$2/hlaall.forfastq F=${runs_dir}/$1/$2/fastq_for_gz F2=${runs_dir}/$1/$2/fastq_rev_gz VALIDATION_STRINGENCY=SILENT QUIET=true
${java} -Xmx${heap}m -jar ${picard}/SamToFastq.jar I=${runs_dir}/$1/$2/hlaall.forfastq F=${runs_dir}/$1/$2/fastq_for_gz.fastq F2=${runs_dir}/$1/$2/fastq_rev_gz.fastq VALIDATION_STRINGENCY=SILENT QUIET=true

rm -rf ${tmp_folder}/$3

rm ${runs_dir}/$1/$2/hlaall.srt.bam
rm ${runs_dir}/$1/$2/hlaall.cleaned.bam
rm ${runs_dir}/$1/$2/hlaall.fixed.bam
rm ${runs_dir}/$1/$2/hlaall.forfastq
