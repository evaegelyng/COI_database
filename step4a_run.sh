#!/bin/bash
#SBATCH --partition normal
#SBATCH --mem 32G
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH --begin 04:00

# Begin time corresponds to 10 pm Eastern time, following NCBIs recommendations on large jobs
# Remember to activate conda environment mares3

Rscript scripts/step4a_taxid_addition.r