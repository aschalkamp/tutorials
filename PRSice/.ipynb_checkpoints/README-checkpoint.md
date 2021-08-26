# PRSice2 
tool to compute polygenic risk scores

## Resources
https://choishingwan.github.io/PRS-Tutorial/
https://www-nature-com.abc.cardiff.ac.uk/articles/s41596-020-0353-1

## Input
- Base data: GWAS summary statistics
- Target data: 
- covariates

## Preprocessing

### QC on base data
- get the most high powered GWAS and most recent one
- content: 
* CHR: The chromosome in which the SNP resides
* BP: Chromosomal coordinate of the SNP
* SNP: SNP ID, usually in the form of rs-ID
* A1: The effect allele of the SNP
* A2: The non-effect allele of the SNP
* N: Number of samples used to obtain the effect size estimate
* SE: The standard error (SE) of the effect size esimate
* P: The P-value of association between the SNP genotypes and the base phenotype
* OR: The effect size estimate of the SNP, if the outcome is binary/case-control. If the outcome is continuous or treated as continuous then this will usually be BETA
* INFO: The imputation information score
* MAF: The minor allele frequency (MAF) of the SNP
- chip-heritability: h2snp < 0.05 (can be computed with LDSC)
- effect allele: check that right direction
- file transfer: md5sum
- genome build: base and target must have same, if not transfer with LiftOver
- standard QC: filter SNPs on MAF<1% or INFO<0.8
- duplicate SNP: remove if there are any
- ambiguous SNP: if base and target are on different chips and information about strand missing, SNPs should be deleted (make sure A/T and C/G are paired)
- sex check: indicates a mixup of samples and should be removed (genetic sex not same as reported sex)
- sample overlap: base data should not be computed on samples that are in target data
- relatedness: when base and target samples closely related might lead to overconfidence

### QC on target data
- individual-level genotype-phenotype data
- content:
* SNP data in plink/bed format
* pheno data
- sample size: at least 100
- file transfer: md5sum
- genome build: should match base data else transfer with LiftOver
- standard QC: see plink/QC tutorial (hwe, maf, geno, mind, indep pairwise, het)
- mismatching SNP: flip alleles if complement and remove mismatching ones
- remove duplicate SNP

### merge covariates (MDS/PCA,age,education,gender)
- get MDS/PCA for population stratification
- put in one txt file

## Command
Rscript PRSice.R \
    --prsice PRSice_linux \
    --base Height.QC.gz \
    --target EUR.QC \
    --binary-target F \
    --pheno EUR.height \
    --cov EUR.covariate \
    --base-maf MAF:0.01 \
    --base-info INFO:0.8 \
    --stat OR \
    --or \
    --out EUR
## Visualize
- bar plot of r2 for different p-thresholds
- scatterplot/histogram of PRS and phenotype