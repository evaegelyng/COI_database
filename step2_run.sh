#!/bin/bash
#SBATCH --partition normal
#SBATCH --mem 64G
#SBATCH -c 1
#SBATCH -t 72:00:00

# Remember to activate conda environment mares3

Rscript scripts/step2_retrieve_bold.r