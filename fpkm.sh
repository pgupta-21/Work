#no trimming
#hisat index
#alignment BUT with cufflinks option as follows:
#	--rna-strandness RF
#	--dta-cufflinks
#
#then, convert to bam and sorted bam files
#input to cuffnorm
#	cuffnorm -o cuffnorm/ -p 72 genome.gtf file1.sorted.bam file2.sorted.bam file3.sorted.bam
