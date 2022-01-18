# Conditional analysis of 2 traits using GCTA

https://jrevez.github.io/vitaminD/3_BMI.html

Idea: assess genetic relationship of two traits based on GWAS summary statistics

Data: Ukbiobank GWAS from Nealelab https://docs.google.com/spreadsheets/d/1kvPoupSzsSFBNSztMzl04xMoSC3Kcx3CrjVf4yBmESU/
- vitamin D
- BMI
- variants
UKBiobank bed file for 20K random european ancestry

## 1. genetic correlation
assessed with LDSC
LDSC_geneticcorrelation_2traits.sh

## 2. generalised summary-data-based Mendelian randomisation (GSMR) to test for putative causal effects
explore causal effects between two traits
GSMR.sh


## 3. multi-trait-based conditional & joint analysis (mtCOJO) 
condition a trait GWAS on another trait and estimate its effect on the trait
mtCOJO.sh