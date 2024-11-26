#!/bin/sh
 
# Define the input FASTA file
fasta_file="extracted_sequences.fasta"
 
# Function to get the score of an amino acid
get_amino_acid_score() {
    case "$1" in
        A) echo 1 ;;
        C) echo 2 ;;
        D) echo 3 ;;
        E) echo 4 ;;
        F) echo 5 ;;
        G) echo 6 ;;
        H) echo 7 ;;
        I) echo 8 ;;
        K) echo 9 ;;
        L) echo 10 ;;
        M) echo 11 ;;
        N) echo 12 ;;
        P) echo 13 ;;
        Q) echo 14 ;;
        R) echo 15 ;;
        S) echo 16 ;;
        T) echo 17 ;;
        V) echo 18 ;;
        W) echo 19 ;;
        Y) echo 20 ;;
        *) echo 0 ;;  # Default score for unknown amino acids
    esac
}
 
# Temporary variables
seq_id=""
seq=""
 
# Read the FASTA file line by line
while read -r line; do
    # If the line starts with '>', it indicates a header line
    if echo "$line" | grep -q "^>"; then
        # If we have a sequence from the previous header, calculate its score
        if [ -n "$seq" ]; then
            score=0
            i=1
            while [ $i -le $(echo -n "$seq" | wc -c) ]; do
                aa=$(echo "$seq" | cut -c $i)
                score=$((score + $(get_amino_acid_score "$aa")))
                i=$((i + 1))
            done
            echo "$seq_id score: $score"
        fi
 
        # Reset sequence variables and save the current header
        seq_id="$line"
        seq=""
    else
        # Concatenate sequence lines
        seq="$seq$line"
    fi
done < "$fasta_file"
 
# Calculate the score for the last sequence
if [ -n "$seq" ]; then
    score=0
    i=1
    while [ $i -le $(echo -n "$seq" | wc -c) ]; do
        aa=$(echo "$seq" | cut -c $i)
        score=$((score + $(get_amino_acid_score "$aa")))
        i=$((i + 1))
    done
    echo "$seq_id score: $score"
fi
