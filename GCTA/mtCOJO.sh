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
module load gcta

vitd_prefix=vitD
bmi_prefix=bmi

# Directories
sumstats=/scratch/c.c21013066/data/ukbiobank/sumstatsNealelab
results=/scratch/c.c21013066/data/tutorial/GCTA/results
tmpDir=$results/tmpDir
ldscDir=/scratch/c.c21013066/data/atlas/LDScore

# ########################
# Prepare files to run mtCOJO
# ########################

# Vitamin D conditioned on BMI
echo "vitD $sumstats/3_maFormat/$vitd_prefix.ma
bmi $sumstats/3_maFormat/$bmi_prefix.ma" > $tmpDir/files4mtCOJO.${vitd_prefix}_condition_on_$bmi_prefix

# BMI conditioned on vitamin D
echo "bmi $sumstats/3_maFormat/$bmi_prefix.ma
vitD $sumstats/3_maFormat/$vitd_prefix.ma" > $tmpDir/files4mtCOJO.${bmi_prefix}_condition_on_$vitd_prefix

# ########################
# Run mtCOJO
# ########################

# Files/settings to use
ld_ref=/scratch/c.mpmcs1/AK/NEUROCHIP/step8_gwa_cond_analysis/mtcojo_ref_data.txt 
#ids2keep=$medici/v3Samples/ukbEURu_v3_all_20K.fam
ldscFiles=$ldscDir/eur_w_ld_chr/
#analysis=${vitd_prefix}_condition_on_$bmi_prefix
analysis=${bmi_prefix}_condition_on_$vitd_prefix
#analysis=/scratch/c.c21013066/data/tutorial/GCTA/data/mtcojo_summary_data_ad_ibd.list
gwasDatasets=$tmpDir/files4mtCOJO.$analysis
output=$results/mtcojo/mtcojo.$analysis

# Run mtCOJO
cd $results

tmp_command="gcta64 --mbfile $ld_ref  \
                   --mtcojo-file $gwasDatasets \
                   --ref-ld-chr $ldscFiles \
                   --w-ld-chr $ldscFiles \
                   --threads 16  \
                   --out $output"
echo $tmp_command
eval $tmp_command
