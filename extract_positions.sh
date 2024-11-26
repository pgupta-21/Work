#!/bin/sh
 
# Define file names
fasta_file="multifasta.fasta"
positions_file="positions.txt"
output_file="extracted_sequences.fasta"
 
# Ensure the output file is empty before starting
: > "$output_file"
 
# Read positions file line by line
while read -r line; do
  # Extract sequence ID, start position, and end position
  seq_id=$(echo "$line" | awk '{print $1}')
  start=$(echo "$line" | awk '{print $2}')
  end=$(echo "$line" | awk '{print $3}')
 
  # Use awk to extract the sequence from the FASTA file
  awk -v id="$seq_id" -v start="$start" -v end="$end" '
    BEGIN { RS=">"; FS="\n" }
    $1 ~ id {
      # Concatenate all sequence lines
      seq=""
      for (i=2; i<=NF; i++) seq = seq $i
      # Extract the desired portion and print with header
      print ">" id "\n" substr(seq, start, end-start+1)
    }
  ' "$fasta_file" >> "$output_file"
 
done < "$positions_file"
 
echo "Desired sequences have been extracted to $output_file."
