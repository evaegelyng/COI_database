#!/bin/bash
#SBATCH --mem 16G
#SBATCH -c 1
#SBATCH -t 4:00:00

#Remember to activate conda environment mares3

Rscript scripts/step4c_taxid_processing.r