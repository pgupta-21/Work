#!bin/bash
# Creating blast database
find . -type f -name "_GT600.fasta" | xargs cat > out.fasta

/usr/local/share/bin/makeblastdb -in out.fasta -parse_seqids -out ./blastdb/seq -blastdb_version 5 -dbtype nucl

###########
# Performing a blast on given fasta file
#BLASTDB=/mnt/pg/fsp/TESTDB/
#/usr/local/share/bin/blastn -query 18_HB1391A.fasta -db ./TESTDB/seq -out out_blast.txt
