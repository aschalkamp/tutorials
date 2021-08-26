# LD score regression
heritability estimation tool

## Resources
https://github.com/bulik/ldsc/wiki/Heritability-and-Genetic-Correlation

## Data
- LDScores: computed on european ancestry from 1kGenome stored at data/atlas/LDScore
wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
tar -jxvf eur_w_ld_chr.tar.bz2
- GWAS summary statistics (height at data/tutorial/PRSice/Height.gwas)
- source data of LDScores for data munging (transforming GWAS stats to SNP format of LDSCOREs)
get https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
bunzip2 w_hm3.snplist.bz2

## Output
- out_h2.log: holds info about all made QC steps and the final computed heritability estimate

## More
- can run --rg instead of --h2 if want to investigate the genetic correlation
- can input multiple GWAS stat files