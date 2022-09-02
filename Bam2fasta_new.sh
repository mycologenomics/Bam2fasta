#!/bin/sh

PATH=$PATH:/apps/samtools/1.3.1/bin/samtools:/apps/samtools/0.1.18/bin/samtools:/apps/bcftools/1.3.1:/apps/tabix/0.2.5

inputBam=$1
output_name=$2
reference=/rds/general/project/fisher-aspergillus-reference/live/Aspergillus_fumigatus.CADRE.12.dna.toplevel.fa
output_dir=/rds/general/project/fisher-aspergillus-results/live/Run9/$output_name

/apps/samtools/1.3.1/bin/samtools mpileup -ABuf $reference $inputBam | /apps/bcftools/1.3.1/bin/bcftools call -cOz --pval-threshold 0.99 > $output_dir/$output_name.vcf.gz

/apps/tabix/0.2.6/bin/tabix -p vcf $output_dir/$output_name.vcf.gz 

cat $reference | /apps/bcftools/1.3.1/bin/bcftools consensus $output_dir/$output_name.vcf.gz > $output_dir/$output_name.fastq

/apps/samtools/0.1.18/misc/seqtk fq2fa $output_dir/$output_name.fastq > $output_dir/$output_name.fasta

rm $output_dir/$output_name.fastq $output_dir/$output_name.vcf.gz $output_dir/$output_name.vcf.gz.tbi
