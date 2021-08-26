#!/bin/bash --login
#SBATCH --mail-type=NONE # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=SchalkampA@cardiff.ac.uk # Your email address
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=1
#SBATCH --mem=32gb
#SBATCH --account=scw1329
#SBATCH --time=00:10:00 # Time limit hh:mm:ss
#SBATCH -o /scratch/c.c21013066/log/plink/%x-%A-%a.out
#SBATCH -e /scratch/c.c21013066/log/plink/%x-%A-%a.err
#SBATCH --job-name=tutorialGWAS # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load plink/1.9

path='/scratch/c.c21013066/data/tutorial/PRSice/EUR'

cd $path

plink \
    --file EUR.QC \
    --pheno EUR.height
    --assoc \
    --out heightGWAS