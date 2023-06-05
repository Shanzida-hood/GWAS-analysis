# Title: QC and Data preparation steps for Michigan server _PanScan2
# Author:Shanzida Jahan Siddique
# Date: 06/18/2021
#################################################################################
# Datasets and principal component analysis files 
####################################################################### 
Datasets and Principal components analysis files (age,covariates,case-control) for PanScan2 are in Datasets folder.
panscan2_2414qc_np.bim
panscan2_2414qc_np.bed  panscan2_2414qc_np.fam
Principal Component analysis files:pan4_3_7_14.sample  
[jhpce01 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset]$ ls
pan4_3_7_14.sample      panscan2_2414qc_np.bim
panscan2_2414qc_np.bed  panscan2_2414qc_np.fam

# create a new folder imputation_correct 
#######################################################################
Since previous result were wrong so all results will be in the new folder imputation_correct.
jhpce01 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset/imputation_correct
# export plink in this folder
########################################################################
Since I would run plink for the qc so at first I exported plink in this folder.
[jhpce01 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct]$ export PATH=$PATH:/users/sjahansi/bin/plink
## .bim file has how many variants:
########################################################
543727 variants loaded from .bim file.
3332 people (1776 males, 1556 females) loaded from .fam.

## remove autosome 
########################################################################
[jhpce01 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset]$ plink --bfile /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset/panscan2_2414qc_np --autosome --make-bed --mpheno 12 --pheno /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset/pan4_3_7_14.sample  --out /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_autosome

## remove geno with the file of remove autosome 
#######################################################

plink --bfile /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_autosome --geno 0.01 --make-bed --mpheno 12 --pheno /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset/pan4_3_7_14.sample  --out /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_geno

## remove mind with the file of remove geno
########################################################
plink --bfile /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_geno --mind 0.02 --make-bed --mpheno 12 --pheno /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/Dataset/pan4_3_7_14.sample  --out /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_mind

## Number of SNPS and INdividuals
##########################################################

After geno and mind filter out I got 535601 variants and 3332 people pass filters and QC.
###Data Preparation for Michigan Imputation server
####################################################################
### Pipeline  for the preparation of Dataset
####################################################################
## Download tools and sites 
[compute-107 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct
 wget http://www.well.ox.ac.uk/~wrayner/tools/HRC-1000G-check-bim-v4.2.7.zip
 wget ftp://ngs.sanger.ac.uk/production/hrc/HRC.r1-1/HRC.r1-1.GRCh37.wgs.mac5.sites.tab.gz
 
 #### unzip and gunzip these two files 
 ###############################################################################
 [compute-107 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct]$ unzip HRC-1000G-check-bim-v4.2.7.zip 
 [compute-107 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct]$ gunzip HRC.r1-1.GRCh37.wgs.mac5.sites.tab.gz
 All are saved in /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct.
 ### Export plink in the current folder
 ############################################################
 Since I did all file conversition in plink.So at first I exported plink in the current folder.
 [compute-107 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct]$ export PATH=$PATH:/users/sjahansi/bin/plink
 ## Convert ped/map to bed
 #############################################################
 [compute-107 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation]$ plink --bfile /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_mind --make-bed --out /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation/bedfile_imputation
 #### Create a frequency file
 #############################################################
 [compute-077 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation]$ plink --bfile /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/file_mind --freq  --out /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation/freqfile_imputation
 
 #### Execute perl script 
 ###########################################################
 ### perl script need big memory to run.So I issued here qrsh -l mem_free=60G,h_vmem=60G,h_fsize=60G -now n. -now n will helped to to stay in que.
 [compute-107 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan1/imputation_correct/bedfile_imputation]$ qrsh -l mem_free=60G,h_vmem=60G,h_fsize=60G -now n
 #### Run perl script 
 ##############################
 
 [compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation]$ perl /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/HRC-1000G-check-bim.pl --b /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation/bedfile_imputation.bim --f /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation/freqfile_imputation.frq --r /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/HRC.r1-1.GRCh37.wgs.mac5.sites.tab -h


  Matching to HRC
 
 Position Matches
 ID matches HRC 533780
 ID Doesn't match HRC 1523
 Total Position Matches 535303
ID Match
 Different position to HRC 123
No Match to HRC 173
Skipped (X, XY, Y, MT) 0
Total in bim file 535601
Total processed 535599

Indels (ignored in r1) 0

SNPs not changed 80396
SNPs to change ref alt 374322
Strand ok 267827
Total Strand ok 454718

Strand to change 265965
Total checked 535426
Total checked Strand 533792
Total removed for allele Frequency diff > 0.2 726
Palindromic SNPs with Freq > 0.4 383


Non Matching alleles 1251
ID and allele mismatching 665; where HRC is . 664
Duplicates removed 2


After completing that I got sh Run-plink.sh.
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation]$ ls
Run-plink.sh
I ran that and got separate bed,bim and fam file for chromosomes 1-22.
Export plink in the curreent folder.
Run sh Run-plink.sh
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation]$ export PATH=$PATH:/users/sjahansi/bin/plink
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation]$ sh Run-plink.sh

I ran that and got separate bed,bim and fam files for chromosomes 1-22.
## Create vcf using VcfCooker

We didn’t follow this steps.We created vcf file by using plink.
## Additional Tools : Convert ped/map files to VCF files
########################################################################
export plink and bcftools in the current folder.and then created vcf files by the following plink commands.
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan]$ export PATH=$PATH:/users/sjahansi/bin/bcftools/bcftools-1.11
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan]$ export PATH=$PATH:/users/sjahansi/bin/plink
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan]$ plink --bfile /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/bedfile_imputation/bedfile_imputation-updated-chr22 --recode vcf-iid --out /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan/chr22_before_imputation
Create a sorted vcf.gz file using BCFtools:
########################################################
[compute-116 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan]$ bcftools sort chr1_before_imputation.vcf -Oz -o /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan/chr1_before_imputation.vcf.gz

Check vcf:
################################
/users/sjahansi/bin/checkVCF/checkVCF.py -r /users/sjahansi/bin/checkVCF/hs37d5.fa -o chr1 /dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_correct/vcf_files_upload_Michigan/chr1_before_imputation.vcf.gz
checkVCF.py -r human_g1k_v37.fasta -o out mystudy_chr1.vcf.gz
Check the uploaded .bim file ,uploaded vcf file and downloaded vcf file from michigan imputation server 
#############################################################################################################

[compute-088 /users/sjahansi/bin/bcftools/bcftools-1.11]$ ./bcftools query -f 'pos=%POS\n'
/dcl01/klein/data/imputation/PANC4_Michigan/output/PanScan2/imputation_results/file_Michigan/vcf_file_download_michiganserver_panc4/chr3.dose.vcf.gz
| tail -3
