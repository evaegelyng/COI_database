#!/bin/bash
#SBATCH --partition normal
#SBATCH --mem 8G
#SBATCH -c 1
#SBATCH -t 12:00:00

echo '#!/bin/bash' | cat - ./taxid_commands_addition.txt > scripts/perl_taxid_additioncommands.sh
chmod +x scripts/perl_taxid_additioncommands.sh
scripts/perl_taxid_additioncommands.sh 
OUTPUT="$(wc -l taxid_commands_addition.txt | awk '{print $1}')"
tail -n ${OUTPUT} scripts/taxdump_edit/names.dmp | awk '{print $1}'> newtaxids.txt
