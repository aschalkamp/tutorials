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
#SBATCH --job-name=tutorialQCshort # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load plink/1.9
path='/scratch/c.c21013066/data/tutorial/PRSice/EUR'
scripts='/scratch/c.c21013066/data/tutorial/plink/QC'
cd $path

# standard values for QC
plink \
    --bfile EUR \
    --maf 0.01 \
    --hwe 1e-6 \
    --geno 0.01 \
    --mind 0.01 \
    --write-snplist \
    --make-just-fam \
    --out EUR.QC

# remove highly correlated
plink \
    --bfile EUR \
    --keep EUR.QC.fam \
    --extract EUR.QC.snplist \
    --indep-pairwise 200 50 0.25 \
    --out EUR.QC
    
# compute heterozygoty
plink \
    --bfile EUR \
    --extract EUR.QC.prune.in \
    --keep EUR.QC.fam \
    --het \
    --out EUR.QC
    
Rscript ${scripts}/get_het_valid.R

# sex check
plink \
    --bfile EUR \
    --extract EUR.QC.prune.in \
    --keep EUR.valid.sample \
    --check-sex \
    --out EUR.QC
    
Rscript ${scripts}/sex_check.R

# relatedness
plink \
    --bfile EUR \
    --extract EUR.QC.prune.in \
    --keep EUR.QC.valid \
    --rel-cutoff 0.125 \
    --out EUR.QC
    
# write final QCed files
plink \
    --bfile EUR \
    --make-bed \
    --keep EUR.QC.rel.id \
    --out EUR.QC \
    --extract EUR.QC.snplist \