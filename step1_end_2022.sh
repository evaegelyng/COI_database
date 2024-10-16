#!/bin/bash
#SBATCH --partition normal  # Eva
#SBATCH --mem 4G            # Eva
#SBATCH -c 1                # Eva
#SBATCH -t 72:00:00          # Eva

#### Before running the script, activate the conda environment mares3

#### Here we download all relevant genbank files

cd ./taxids/reformatted_taxids

#ls | grep .txt | parallel -j 1 "perl ../../coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx {}" # Eva replaced with for loop below to improve download success

FILES=(`ls *.txt`)

for inputFile in  ${FILES[@]}
do
  echo "Working on" $inputFile
  perl ../../scripts/coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx $inputFile
done

#### Now we'll convert to fasta using the script from: https://rocaplab.ocean.washington.edu/tools/genbank_to_fasta/

for FILE in *.gb
do
echo $FILE 
python2 ../../scripts/genbank_to_fasta.py -i $FILE -o ${FILE/.gb/.fasta} -s whole -d 'pipe' -a 'accessions,organism'
gzip $FILE
done

#### (Re)download genbank files for the txt files that have no corresponding fasta file. For some reason, certain sequences are not downloaded in the initial attempt above.

for inputFile in ${FILES[@]}
do 
  if [ ! -f "${inputFile/.txt/_seqs.fasta}" ]; then 
  echo "Due to no fasta file, retrying " $inputFile
  perl ../../scripts/coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx $inputFile
  fi
done

#### (Re)download genbank files for the txt files that have an empty corresponding fasta file. As explained above, some sequences are only downloaded in the second attempt.
for inputFile in ${FILES[@]}
do
  if [ ! -s "${inputFile/.txt/_seqs.fasta}" ]; then
  echo "Due to empty fasta file, retrying " $inputFile
  perl ../../scripts/coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx $inputFile
  fi
done

#### Convert the additional files from "redownloading" to fasta format using the script from: https://rocaplab.ocean.washington.edu/tools/genbank_to_fasta/

for FILE in *.gb
do
echo $FILE 
python2 ../../scripts/genbank_to_fasta.py -i $FILE -o ${FILE/.gb/.fasta} -s whole -d 'pipe' -a 'accessions,organism'
gzip -f $FILE # Eva added -f to overwrite existing (empty) genbank files
done

#### Combine all the fasta files
cat *.fasta > ../../genbank_coi.fasta
