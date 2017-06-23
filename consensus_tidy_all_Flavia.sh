#! /bin/bash -x
# to go from consensus fastas to alignements on iplant
# Need a folder called By_locus, a list of loci called “locus_list” and a list of files called “fasta_files”
# Assumes you have just run python3 switch_multifastas.py and moved to folder By_locus

# Catherine Kidner 23 Juen 2017


# Replace name of seq with just the accession, convert bases to uppercase, mafft align, strict trim and summarise

acc=$1

echo "You're working on accession $1"


input=${acc}.fasta
fasta=${acc}_clean.fasta
mafft=${acc}_mafft.fasta
strict=${acc}_strict.fna
summary=${acc}_summary.txt

#Remove the locus names in the headers and clean up non standard char

sed "s/\.fast_.*//g" $input | sed '/^[^>]/s/[^ATGCactg]/N/g' > $fasta

mafft --auto --thread 8 $fasta > $mafft

# Use trimmal to trim the alignemnts of gappy regions and output as nexus for PAUP

trimal -in $mafft -out $strict -strict 

# use amas to get summary info for each alignment

python3 ~/amas-0.93/amas/AMAS.py -f fasta -d dna -i $strict -s -o $summary

exit 0
