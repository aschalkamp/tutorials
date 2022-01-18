#!/bin/bash --login
#SBATCH --mail-type=NONE # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=SchalkampA@cardiff.ac.uk # Your email address
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=1
#SBATCH --mem=32gb
#SBATCH --account=scw1329
#SBATCH --time=00:10:00 # Time limit hh:mm:ss
#SBATCH -o /scratch/c.c21013066/log/gcta/%x-%A-%a.out
#SBATCH -e /scratch/c.c21013066/log/gcta/%x-%A-%a.err
#SBATCH --job-name=tutorial # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load ldsc

vitd_prefix=vitD
bmi_prefix=bmi

# Directories
sumstats=/scratch/c.c21013066/data/ukbiobank/sumstatsNealelab
results=/scratch/c.c21013066/data/tutorial/GCTA/results
tmpDir=$results/tmpDir
ldscDir=/scratch/c.c21013066/data/atlas/LDScore


# ########################
# Prepare files to run GSMR
# ########################

# --- Create file with paths to LD reference data
#     Use random set of 20K unrelated Europeans previously extracted with fastGWA variants for COJO analysis
#echo $random20k_dir/ukbEURu_imp_chr1_v3_impQC_random20k_maf0.01 > $tmpDir/ukb_ref_data.txt 
#for i in `seq 2 22`
#do 
#    echo $random20k_dir/ukbEURu_imp_chr${i}_v3_impQC_random20k_maf0.01 >> $tmpDir/ukb_ref_data.txt
#done
echo "bmi $sumstats/3_maFormat/$bmi_prefix.ma" > $tmpDir/files4gsmr.bmi
echo "vitD $sumstats/3_maFormat/$vitD_prefix.ma" > $tmpDir/files4gsmr.vitD

# ########################
# Run bi-directional GSMR
# ########################

# Files/settings to use
ld_ref=/scratch/c.mpmcs1/AK/NEUROCHIP/step8_gwa_cond_analysis/mtcojo_ref_data.txt #$tmpDir/ukb_ref_data.txt
#ids2keep=
exposure=$tmpDir/files4gsmr.bmi
outcome=$tmpDir/files4gsmr.vitD

# Run GSMR without HEIDI
cd $results

output=$results/gsmr/$prefix.$bmi_prefix.gsmr_with20kUKB_noHeidi
tmp_command="gcta64 --mbfile $ld_ref  \
                   --gsmr-file $exposure $outcome \
                   --gsmr-direction 2 \
                   --heidi-thresh 0  \
                   --effect-plot \
                   --gsmr-snp-min 10 \
                   --gwas-thresh 5e-8 \
                   --threads 16  \
                   --out $output"
echo $tmp_command
eval $tmp_command


# Run GSMR with new HEIDI-outlier method
output=$results/gsmr/$prefix.$bmi_prefix.gsmr_with20kUKB_2heidi
tmp_command="gcta64 --mbfile $ld_ref  \
                   --gsmr-file $exposure $outcome \
                   --gsmr-direction 2 \
                   --effect-plot \
                   --gsmr-snp-min 10 \
                   --gwas-thresh 5e-8 \
                   --gsmr2-beta  \
                   --heidi-thresh  0.01 0.01  \
                   --threads 16  \
                   --out $output"
echo $tmp_command
eval $tmp_command
