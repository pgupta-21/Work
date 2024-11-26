#!/bin/bash

# Deleting extra characters from fastq file names
for file in *.gz; do mv "$file" "${file/_001/}"; done

# Quality check and trimming
for f1 in *_R1.fastq.gz;
do
	f2=${f1%%_R1.fastq.gz}"_R2.fastq.gz"
	fastp -i $f1 -I $f2 -o ./"trimmed-$f1" -O ./"trimmed-$f2"
done

# Creating a hisat2 index
mkdir index
hisat2-build -p 72 genome.fa ./index/index_name

# Aligning reads to the reference genome
mkdir align
for f1 in *_R1.fastq.gz; do
	f2=${f1%%_R1.fastq.gz}"_R2.fastq.gz"
	hisat2 -p 72 -x ./index/index_name -1 $f1 -2 $f2 --rna-strandness RF --dta-cufflinks -S ./align/"$f1.sam"
done

# Converting sam to bam files
for file in *.sam;
do
	samtools view -@ 72 -bS $file > "$file.bam"
done

# Sorting bam files
for file in *.bam;
do
	samtools sort -@ 72 $file -o $file.sorted.bam
done

# Renaming the output files
for file in *.sorted.bam; do mv "$file" "${file/_R1.fastq.gz.sam.bam/}"; done

# Fpkm values
cuffnorm -o cuffnorm/ -p 72 genome.gtf file1.sorted.bam file2.sorted.bam file3.sorted.bam

# Quantification of counts
featureCounts -t exon -g gene_id -p -T 16 -a annotation_file.gtf -o ./fcounts.txt ./align/file.sorted.bam # -p is for paired end reads

