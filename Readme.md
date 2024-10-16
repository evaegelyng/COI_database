#Follow these steps when making a new version of this database. For each script, see further instructions in the comments inside the script

1. Copy the folder backup to the new database folder, and make a symbolic link to the scripts:

ln -s backup/scripts/ scripts

To obtain the needed software for the pipeline, either i) use the yml files in the backup/environments folder to recreate Eva's environments:

conda env create -f environment.yml

The yml files have been made using the option --from-history, such that only packages that were directly installed are included. This should make it easier to recreate the environments.

or ii) use Eva's environments directly, by using the full path to the environments (permissions may need to be changed), e.g.

conda activate /home/evaes/miniconda3/envs/mares

or iii) build your own environments from scratch, using the MARES GitHub documentation. This may be preferable, as all packages will be updated and it may be that you can decrease the number of different environments used

2. Run ebot_taxonomy3.plx (in coi_ret folder). If you get the error "loadable library and perl binaries are mismatched", you may need to change the path(s) to perl, e.g.:
export PERL5LIB=/home/evaes/miniconda3/envs/myenv.3/bin/perl5.26.2
export PERL_LOCAL_LIB_ROOT=/home/evaes/miniconda3/envs/myenv.3/bin/perl5.26.2

3. Download and decompress newest NCBI taxonomy in scripts/taxdump_edit folder:
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
tar -xf taxdump.tar.gz
Then update paths to nodes and names files in taxonomy_crawl_for_genus_species_list.plx (coi_ret folder)

4. Run step1_NCBI_COI_Retrieval.sh, i.e. in the root folder, run:
sbatch --account edna scripts/step1_NCBI_COI_Retrieval.sh
You may need to change the perl paths back to do this...

5. Run the remaining steps :-)