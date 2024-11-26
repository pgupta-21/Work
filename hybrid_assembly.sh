# install busco, flye, pilon

# quality control with reference genome
busco -i reference_genome.fasta -o output -c 8

# ONT reads
flye --nano-raw ONT.fastq --out-dir output --threads 16

# quality check of the assembly

# assembly polishing using two steps : alignment and polishing
# bwa-mem
# pilon
