# GWAS
via plink perform genome-wide association analysis

## Data
- use data from PRSice tutorial
- must be QCed (see tutorial/plink/QC)

## Command
plink --bfile FILE -assoc --adjust --out NAME

### Variations
- binary or quantitative
- adjust for multiple testing automatically

## Visualizations
- Manhattan
- QQ
