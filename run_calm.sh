#!/bin/bash

#SBATCH --job-name=calm_nf_test
#SBATCH -p compute
#SBATCH -q batch
#SBATCH -t 01:00:00
#SBATCH --mem=2G
#SBATCH --ntasks=1

cd $SLURM_SUBMIT_DIR

# LOAD NEXTFLOW
module use --append /projects/omics_share/meta/modules
module load nextflow

# RUN TEST PIPELINE
nextflow main.nf \
-profile sumner \
--workflow calm \
--gen_org sepi \
--sample_folder '/fastscratch/doingg/calm_nf/samps' \
--pubdir '/fastscratch/doingg/calm_nf/outputDir' \
-w '/fastscratch/doingg/calm_nf/outputDir/work'
