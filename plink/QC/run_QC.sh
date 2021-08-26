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
#SBATCH --job-name=tutorialQC # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load anaconda
source activate py38R
module load plink/1.9
path='/scratch/c.c21013066/data/tutorial/PRSice'
out='/scratch/c.c21013066/data/tutorial/plink/QC'
FILE='EUR/EUR'
cd $out

############## STEP 1 MISSINGNESS #################
# generates plink.imiss (how many SNP per subject missing) and plink.lmiss (how many subjects per SNP missing)
# common thresholds are 0.2 and later 0.02 (first filter SNPs then subjects)
plink --bfile ${path}/${FILE} --missing --out miss_stats
plink --bfile ${path}/${FILE} --geno 0.2 --make-bed --out QC10
plink --bfile QC10 --mind 0.2 --make-bed --out QC11

############# STEP 2 sex discrepancy ##############
# a priori determined as females must have a F value of <0.2
# subjects who were a priori determined as males must have a F value >0.8
# F value is based on the X chromosome inbreeding (homozygosity) estimate.
plink --bfile QC11 --check-sex
# remove these
grep "PROBLEM" plink.sexcheck| awk '{print$1,$2}'> sex_discrepancy.txt
plink --bfile QC11 --remove sex_discrepancy.txt --make-bed --out QC20

############# STEP 3  Minor Allele Frequency ##############
# remove low minor allele frequency SNPs
awk '{ if ($1 >= 1 && $1 <= 22) print $2 }' QC20.bim > snp_1_22.txt
plink --bfile QC20 --extract snp_1_22.txt --make-bed --out QC30
plink --bfile QC30 --freq --out MAF
plink --bfile QC30 --maf 0.05 --make-bed --out QC31
# traditional thresholds lie between 0.01 and 0.05

############# STEP 4  Hardy-Weinberg-Equilibrium ##############
plink --bfile QC31 --hardy
# By default the --hwe option in plink only filters for controls.
# First we use a stringent HWE threshold for controls, followed by a less stringent threshold for the case data.
# plink --bfile FILE --hwe 1e-6 --make-bed --out FILE
# The HWE threshold for the cases filters out only SNPs which deviate extremely from HWE. 
# for continuous traits harder threshold suggested
plink --bfile QC31 --hwe 1e-10 --hwe-all --make-bed --out QC40

############# STEP 5  Heterozygoty rate ##############
plink --bfile QC40 --exclude /scratch/c.c21013066/data/atlas/PGS/inversion.txt --range --indep-pairwise 50 5 0.2 --out QC50
# 50 window size, 5 SNPs to shift the window at each step, 0.2 multiple correlation coefficient
plink --bfile QC40 --extract QC50.prune.in --het --out Heterozygoty
python /scratch/c.c21013066/PPMI_DataPreparation/genetic/scripts/get_het_fail.py $path
# create list of subjects deviating more than 3std from rate mean
plink --bfile QC40 --remove het_fail.txt --make-bed --out QC51

########### STEP 6 Relatedness ####################
plink --bfile QC51 --extract QC50.prune.in --genome --min 0.2 --out pihat_min02
# delete individual with lower call rate from the related pairs