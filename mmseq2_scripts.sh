#!bin/bash
# Redundancy with 100% sequence identity
mmseqs createdb file.fasta fasta.db
mmseqs clusthash fasta.db clusthash.db --min-seq-id 1.00
mmseqs clust fasta.db clusthash.db test.clust
mmseqs createseqfiledb fasta.db test.clust test.clust_clusters

# Clustering of "databases"
mmseqs easy-cluster file.fasta clusterRes tmp
mmseqs easy-linclust file.fasta clusterRes tmp #for larger datasets

# Counting number of sequences in a fasta file
grep -c ">" file.fasta
