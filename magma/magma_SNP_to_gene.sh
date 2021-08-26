#!/bin/bash --login
#SBATCH --mail-type=NONE # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=SchalkampA@cardiff.ac.uk # Your email address
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=1
#SBATCH --mem=32gb
#SBATCH --account=scw1329
#SBATCH --time=00:10:00 # Time limit hh:mm:ss
#SBATCH -o /scratch/c.c21013066/log/magma/%x-%A-%a.out
#SBATCH -e /scratch/c.c21013066/log/magma/%x-%A-%a.err
#SBATCH --job-name=tutorial # Descriptive job name
#SBATCH --partition=c_compute_dri1

module load magma

path='/scratch/c.c21013066/data/tutorial/magma'
cd $path
gene_loc='NCBI37.3.gene.loc'
snp_loc='pos_snp_neurochip.txt'
out='test.txt'
w=0

cmd="magma --annotate window=${w},${w} --snp-loc ${snp_loc} --gene-loc ${gene_loc} --out ${out}"
echo $cmd
eval $cmd