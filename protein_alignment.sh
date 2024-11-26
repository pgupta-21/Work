# Using diamond for large datasets

wget database.fa #eg. BLAST database

diamond makedb --in database.fa -d database #output: database.dmnd

diamond blastp -q query.fa -d database -o out.tsv
