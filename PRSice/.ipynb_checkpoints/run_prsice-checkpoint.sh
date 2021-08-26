#!/bin/bash --login
#SBATCH --mail-type=NONE # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=SchalkampA@cardiff.ac.uk # Your email address
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=1
#SBATCH --mem=32gb
#SBATCH --account=scw1329
#SBATCH --time=00:10:00 # Time limit hh:mm:ss
#SBATCH -o /scratch/c.c21013066/log/prsice/%x-%A-%a.out
#SBATCH -e /scratch/c.c21013066/log/prsice/%x-%A-%a.err
#SBATCH --job-name=tutorial # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load plink/1.9
module load prsice

out='/scratch/c.c21013066/data/tutorial/PRSice'
cd $out

# compute PCs
plink \
    --bfile EUR/EUR.QC \
    --extract EUR/EUR.QC.prune.in \
    --pca 6 \
    --out EUR/EUR
    
Rscript get_cov.R

PRSice.sh \
    --base Height.QC.gz \
    --target EUR/EUR.QC \
    --binary-target F \
    --pheno EUR/EUR.height \
    --cov EUR/EUR.covariate \
    --base-maf MAF:0.01 \
    --base-info INFO:0.8 \
    --stat OR \
    --or \
    --out EUR/EUR

