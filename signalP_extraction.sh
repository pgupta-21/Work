#!/bin/sh
 
# Define file names
full_file="full_proteins.fasta"
no_signalp_file="no_signalp_proteins.fasta"
output_file="signalp_sequences.fasta"
 
# Ensure the output file is empty before starting
> "$output_file"
 
# Extract headers from no_signalp_file
awk 'NR % 2 == 1 {print $1}' "$no_signalp_file" | while read -r header; do
  # Extract the sequence from the full file
  full_sequence=$(grep -A 1 "$header" "$full_file" | tail -n 1)
  # Extract the sequence from the no_signalp_file
  no_signalp_sequence=$(grep -A 1 "$header" "$no_signalp_file" | tail -n 1)
  # Check if the full sequence contains the no-SignalP sequence
  if echo "$full_sequence" | grep -q "$no_signalp_sequence"; then
    # Extract the SignalP sequence
    signalp_sequence=$(echo "$full_sequence" | sed "s/$no_signalp_sequence//")
    # Append to output file if SignalP sequence is non-empty
    if [ -n "$signalp_sequence" ]; then
      echo "$header" >> "$output_file"
      echo "$signalp_sequence" >> "$output_file"
    fi
  fi
done
 
echo "SignalP sequences have been extracted to $output_file."
