# Download infernal through conda
# Download rfam CM dataset through the website

# Searching sequence dataset for all rfam family hits
cmsearch -o out.txt --tblout tbl.txt rfam.cm fasta_file.fa

# Identifying all non coding RNAs from Rfam families in a nucleotide sequence dataset
cmpress Rfam.cm
cmscan --nohmmonly --rfam -o cmscan.out.txt --tblout cmscan.txt rfam.cm fasta_file.fa
