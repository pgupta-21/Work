# only genome assembly

funannotate mask -i scaffolds.fasta --cpus 12 -o MyAssembly.fa
# change header length to less than 16 to avoid downstream errors
# removing every character after second "_" with cut: cut -d "_" -f 1,2 MyAssembly.fa > new_file.fasta

funannotate predict -i new_file.fa -o fun --species "pichia stipitis" --organism other

funannotate iprscan -i fun -c 2 -m local --iprscan_path /mnt/pg/funannotate/lib/interproscan/interproscan-5.66-98.0/interproscan.sh

funannotate annotate -i fun --cpus 12
