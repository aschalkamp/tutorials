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
#SBATCH --job-name=tutorialQCbase # Descriptive job name
#SBATCH --partition=c_compute_dri1

path="/scratch/c.c21013066/data/tutorial/PRSice"
cd $path

# filter SNPs on provided MAF and INFO
gunzip -c Height.gwas.txt.gz |\
awk 'NR==1 || ($11 > 0.01) && ($10 > 0.8) {print}' |\
gzip  > Height.gz

# remove duplicates
gunzip -c Height.gz |\
awk '{seen[$3]++; if(seen[$3]==1){ print}}' |\
gzip - > Height.nodup.gz

# ambiguous SNP
gunzip -c Height.nodup.gz |\
awk '!( ($4=="A" && $5=="T") || \
        ($4=="T" && $5=="A") || \
        ($4=="G" && $5=="C") || \
        ($4=="C" && $5=="G")) {print}' |\
    gzip > Height.QC.gz