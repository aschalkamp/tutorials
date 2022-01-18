#!/bin/bash --login
#SBATCH --mail-type=NONE # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=SchalkampA@cardiff.ac.uk # Your email address
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=1
#SBATCH --mem=32gb
#SBATCH --account=scw1329
#SBATCH --time=01:00:00 # Time limit hh:mm:ss
#SBATCH -o /scratch/c.c21013066/log/ldsc/%x-%A-%a.out
#SBATCH -e /scratch/c.c21013066/log/ldsc/%x-%A-%a.err
#SBATCH --job-name=tutorial # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load ldsc

ldsc_path='/scratch/c.c21013066/data/atlas/LDScore'
gwas_path='/scratch/c.c21013066/data/tutorial/PRSice'
out_path='/scratch/c.c21013066/data/tutorial/LDSC'

# convert summary statistics to required format
munge_sumstats.py \
--sumstats ${gwas_path}/Height.gwas.txt \
--out ${out_path}/height \
--merge-alleles ${ldsc_path}/w_hm3.snplist

# estimate heritability
ldsc.py \
--h2 ${out_path}/height.sumstats.gz \
--ref-ld-chr ${ldsc_path}/eur_w_ld_chr/ \
--w-ld-chr ${ldsc_path}/eur_w_ld_chr/ \
--rcond=None \
--out ${out_path}/height_h2