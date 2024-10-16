#!/bin/bash
#SBATCH --partition normal
#SBATCH --mem 8G
#SBATCH -c 1
#SBATCH -t 4:00:00

cd ./taxid_process # Eva added
cut -f1 -d" " Eukaryota_NOBAR_BOLD_NCBI_sl_reformatted.fasta > Eukaryota_NOBAR_BOLD_NCBI_sl_reformatted_blast.fasta
awk 'NR % 2 == 1' Eukaryota_NOBAR_BOLD_NCBI_sl_reformatted.fasta | sed 's|[>,]||g' - > Eukaryota_informative_name_table.tsv
awk 'NR % 2 == 1' Eukaryota_NOBAR_BOLD_NCBI_sl_reformatted.fasta  | awk -F" " '{print $(NF-1)}' > Eukaryota_taxids.txt
awk 'NR % 2 == 1' Eukaryota_NOBAR_BOLD_NCBI_sl_reformatted_blast.fasta | sed 's|[>,]||g' - > seqnames_Eukaryota.txt
paste seqnames_Eukaryota.txt Eukaryota_taxids.txt | column -s $' ' -t > cust_taxid_map
makeblastdb -in Eukaryota_NOBAR_BOLD_NCBI_sl_reformatted_blast.fasta -dbtype nucl -taxid_map cust_taxid_map -parse_seqids -out Eukaryota_NOBAR.db
mkdir ../BLAST_db
mv Eukaryota_NOBAR.db* ../BLAST_db
