#!bin/bash
# Creating blast database
find . -maxdepth 2 -mindepth 2 -type f -name "_GT600.fasta" | xargs cat > out.fasta

/usr/bin/makeblastdb -in out.fasta -parse_seqids -out ./blastdb/seq -blastdb_version 5 -dbtype nucl
