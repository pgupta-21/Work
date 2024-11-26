#!bin/bash

# Using bcftools
# Starting point -> sorted bam files
bcftools mpileup -Ou -f genomic.fa align.sorted.bam | bcftools call -vmO z -o calls.vcf.gz
zcat calls.vcf.gz | vcf-annotate --fill-type | grep -oP "TYPE=\w+" | sort | uniq -c > stats.txt

# Using GATK4
# Starting point -> fastq files
mkdir genome
bwa index genome.fasta
samtools faidx genome.fasta
picard CreateSequenceDictionary REFERENCE=genome.fasta OUTPUT=genome.dict

mkdir aligned
bwa mem -t 8 -R "@RG\tID:SAMPLE_NAME\tPL:ILLUMINA\tSM:SAMPLE_NAME" genome/genome.fasta R1.fastq.gz R2.fastq.gz > paired.sam
gatk MarkDuplicatesSpark -I paired.sam -O sorted_dedup.bam

mkdir results
gatk HaplotypeCaller -R genome/genome.fasta -I aligned/sorted_dedup.bam -O raw_variants.vcf

gatk SelectVariants -R genome/genome.fasta -V raw_variants.vcf --select-type SNP -O raw_SNP.vcf
gatk SelectVariants -R genome/genome.fasta -V raw_variants.vcf --select-type INDEL -O raw_INDEL.vcf

gatk VariantFiltration -R genome/genome.fasta -V raw_SNP.vcf -O filtered_SNP.vcf -filter-name "QD_filter" -filter "QD < 2.0" -filter-name "FS_filter" -filter "FS > 60.0" -filter-name "MQ_filter" -filter "MQ < 40.0" -filter-name "SOR_filter" -filter "SOR > 4.0" -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0" -genotype-filter-expression "DP < 10" -genotype-filter-name "DP_filter" -genotype-filter-expression "GQ < 10" -genotype-filter-name "GQ_filter"
gatk VariantFiltration -R genome/genome.fasta -V raw_INDEL.vcf -O filtered_INDEL.vcf -filter-name "QD_filter" -filter "QD < 2.0" -filter-name "FS_filter" -filter "FS > 200.0" -filter-name "SOR_filter" -filter "SOR > 10.0" -genotype-filter-expression "DP < 10" -genotype-filter-name "DP_filter" -genotype-filter-expression "GQ < 10" -genotype-filter-name "GQ_filter"

gatk SelectVariants --exclude-filtered -V filtered_INDEL.vcf -O ready_INDEL.vcf
cat ready_INDEL.vcf | grep -v -E "DP_filter|GQ_filter" > analysis-ready-INDEL.vcf
gatk SelectVariants --exclude-filtered -V filtered_SNP.vcf -O ready_SNP.vcf
cat ready_SNP.vcf | grep -v -E "DP_filter|GQ_filter" > analysis-ready-SNP.vcf

# Output with only Coverage (AD)
gatk VariantToTable -V analysis-ready-INDEL.vcf -F CHROM -F POS -F REF -F ALT -F TYPE -GF AD -O output_indel.table
gatk VariantToTable -V analysis-ready-SNP.vcf -F CHROM -F POS -F REF -F ALT -F TYPE -GF AD -O output_snp.table

# vcf2bed
# conda install bedops
vcf2bed --deletions < calls.vcf.gz > dels_calls.bed #however, the number of deletions here are different from the stats.txt so be careful while presenting results
