#! /bin/bash -x
# to go from raw seq to consensus on iplant
# Assumes files are in form *_1.sanfastq.gz and are in the folder ~/Documents/iROD/Inga_baits
# Assumes you're working in the folder Process - the attached Volume

# Catherine Kidner 23 Oct 2015


echo "Hello world"

acc=$1

tar=${acc}.tar.gz

rc=~/Documents/iROD/done_consensuses/${acc}_rc.txt
bowtie=~/Documents/iROD/done_consensuses/${acc}_bowtie_output

echo "You're working on accession $1"

# leaving the from-trimmed here in case I need to change this in future

#get the trimmed tar from iROD folder and tidying up the old mess
cp raw_reads/$tar ./
tar -zxvf $tar

rm forward*
rm reverse*

mv f_unpaired.fq.gz f_unpaired.fq
mv r_unpaired.fq.gz r_unpaired.fq

bowtie2 --local  --score-min G,130,8 -x ~/bowtie_index/All_loci -1 f_paired.fq.gz  -2 r_paired.fq.gz  -U f_unpaired.fq.gz,r_unpaired.fq.gz  -S output.sam 2> $bowtie

samtools view -bS output.sam | samtools sort - bam_sorted
samtools index bam_sorted.bam
samtools mpileup -E -uf ~/bowtie_index/All_loci.fna bam_sorted.bam > output.pileup
bcftools view -cg output.pileup > output.vcf

#get read_counts - reads 125bp long

samtools idxstats bam_sorted.bam |grep -v "^\*" | awk '{ depth=125*$3/$2} {print $1, depth}' | sort > $rc

rm *.sam
rm *.pileup
rm *.bam
rm *.bai
rm *.fq
rm *.gz
rm *.vcf

exit 0

