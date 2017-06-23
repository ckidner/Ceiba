#! /bin/bash -x
# to take the hyb baits reads listed, bowtie to Inga baits, convert to bam, make index, pileup and vcf
# to get  stats on bowtie parameters
# Catherine Kidner 21 June 2017

echo "Hello world"
echo -n "Which accession would you like to run through from reads to vcf?  Type just the accession name  "
read acc
echo "You picked to work with: $acc  "
echo -n "which starting intercept would you like to use?  "
read n1
echo -n "Which intercept would you like to end with?  "
read n2
echo -n "Which step would you like to take?  Make sure this is divisible into the interval between starting and ending intercept values  "
read step

intercept=$n1

while [ $intercept -le $n2 ]

do

score=G,${intercept},8
fwd_p=forward_paired.fq.gz
rev_p=reverse_paired.fq.gz
un_p=.forward_unpaired.fq.gz,reverse_unpaired.fq.gz
sam=${acc}.sam
index=${acc}_${intercept}_sorted.bam
pileup=${acc}_${intercept}.pileup
vcf=${acc}_${intercept}.vcf
bowtie=${acc}_${intercept}_bowtie_output
sorted=${acc}_${intercept}_sorted

bowtie2 --local --score-min $score -x ~/bowtie_index/All_loci -1 $fwd_p  -2 $rev_p  -U $un_p  -S $sam 2>$bowtie
samtools view -bS $sam | samtools sort - $sorted
samtools index $index
samtools mpileup -E -uf ~/bowtie_index/All_loci.fna  $index > $pileup
bcftools view -cg $pileup > $vcf
rm *.sam
rm *.pileup
rm *.bai
intercept=$(($intercept + $step))

done

exit 0

