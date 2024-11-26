#!bin/bash

# Interproscan database is in mnt/pg/funannotate/lib/interproscan/interproscan-5.66-98.0/
# Move into the directory

./interproscan.sh -i file.fasta -f XML, tsv --goterms --pathways -b /path_to_output/base_name
