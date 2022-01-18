#!/bin/bash --login
#SBATCH --mail-type=NONE # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=SchalkampA@cardiff.ac.uk # Your email address
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=1
#SBATCH --mem=32gb
#SBATCH --account=scw1329
#SBATCH --time=15:00:00 # Time limit hh:mm:ss
#SBATCH -o /scratch/c.c21013066/log/ldsc/%x-%A-%a.out
#SBATCH -e /scratch/c.c21013066/log/ldsc/%x-%A-%a.err
#SBATCH --job-name=tutorial # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load ldsc

# Directories
sumstats=/scratch/c.c21013066/data/ukbiobank/sumstatsNealelab
results=/scratch/c.c21013066/data/tutorial/GCTA/results
tmpDir=$results/tmpDir
ldscDir=/scratch/c.c21013066/data/atlas/LDScore

bmi_prefix=bmi
vitd_prefix=vitD


# Munge (process sumstats and restrict to HapMap3 SNPs) BMI sumstats
echo "start munging sumstats"
munge_sumstats.py --sumstats $sumstats/1_LDSRFormat/$bmi_prefix.ldHubFormat \
                  --merge-alleles $ldscDir/w_hm3.snplist \
                  --out  $sumstats/2_LDSRMungeFormat/$bmi_prefix
echo "done for 1st trait"
munge_sumstats.py --sumstats $sumstats/1_LDSRFormat/$vitd_prefix.ldHubFormat \
                  --merge-alleles $ldscDir/w_hm3.snplist \
                  --out  $sumstats/2_LDSRMungeFormat/$vitd_prefix
echo "done for 2nd trait"
                  
# Run rg
echo 'run regression for genetic correlation'
ldsc.py --rg  $sumstats/2_LDSRMungeFormat/$vitd_prefix.sumstats.gz,$sumstats/2_LDSRMungeFormat/$bmi_prefix.sumstats.gz\
        --ref-ld-chr $ldscDir/eur_w_ld_chr/ \
        --w-ld-chr $ldscDir/eur_w_ld_chr/ \
        --out $results/ldsc/$vitd_prefix.$bmi_prefix.ldsc.rg
echo "done"
