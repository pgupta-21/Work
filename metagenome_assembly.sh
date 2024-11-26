# Concatenate all fastq.gz files into one
zcat *.gz > final_reads.fastq # it won't be gunzipped anymore

# flye version 2.9 downloaded in a separate environment flye_29 because of an unresolved error in conda
# conda create -n flye_29 -c conda-forge -c bioconda flye=2.9

# Perform assembly using flye
flye --nano-raw final_reads.fastq -o ./output -t 18 #pre Guppy 5 #with and without --meta, results were similar

# Spades assembly
spades.py -k 21,33,55,77 --careful -1 out.R1.fastq.gz -2 out.R2.fastq.gz --cov-cutoff auto -o spades_assembly/

# Change headers
sed -i.bak "s/^>/>M069NU_/" assembly.fasta #according to the file number

# Parse for greater than 600 nucleotides (200 aa, for a better protein db probably)
seqtk seq -L 600 assembly.fa > assembly_GT600.fasta

# Check stats
seqkit stats *.fasta

# Blast
# to compare against the seqpool
/usr/local/share/bin/blastn -query assembly_GT600.fasta -db /bigdata/blastdbv5/seqpool -out /mnt/pg/blast.txt -num_threads 72 #pathway for seqpool -> /bigdata/blastdbv5/seqpool
# form a local blast db using genome.fa
/usr/local/share/bin/makeblastdb -in genome.fa -parse_seqids -dbtype nucl -title db_name -out db/db_name
# blast against new database from genome.fa above
/usr/local/share/bin/blastn -query spades_assembly/scaffolds.fasta -db db/db_name -out blast.txt

# Adding to the seqpool database (?)
