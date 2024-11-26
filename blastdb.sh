#!bin/bash
# creating blast database
find . -maxdepth 2 -type f -name "*_GT600.fasta" | xargs cat > out.fasta

/usr/local/share/bin/makeblastdb -in out.fasta -parse_seqids -out ./TESTDB/seq -blastdb_version 5 -dbtype nucl

###########
# performing a blast on given fasta file
#BLASTDB=/mnt/pg/fsp/TESTDB/
#/usr/local/share/bin/blastn -query 18_HB1391A.fasta -db ./TESTDB/seq -out out_blast.txt
