# MAGMA
gene-set analysis tool, but we will use it simply for annotating SNPs to genes

## Input
- position of SNP (snp_loc.txt): Chr and BP (can be extracted from bim files) (SNP CHR POS) (eg from 1kgenome or from our study data)
- gene location (gene_loc.txt) https://www-ncbi-nlm-nih-gov.abc.cardiff.ac.uk/assembly/GCF_000001405.13/ ('EN','CHR','BP_start','BP_stop','','gene')
- output file name (map_gene_snp.txt)

## Command
this calls magma and looks in specified window for neighbouring genes

magma --annotate window=0,0 --snp-loc snp_loc.txt --gene-loc gene_loc.txt --out map_gene_snp.txt

## Further resources
- https://github.com/NathanSkene/MAGMA_Celltyping: R package that takes care of most of my desired functions
