Ascat based CNV identifcation 

This workflow utilizes ASCAT to reveal correct copy numbers to all loci in the reference genome. This is carried out through the `ascat.R` script. 

-   CWL: workflow_ascat.cwl

Input
#####
The user should provide the following files and parameters:

- `bam` file containing sequences of a tumor sample
- `bam` file containing sequences of a normal sample
- `gender` parameter for the gender information, accepted values: XX (female), XY (male)
- `nthreads` parameter for the number of threads to run Ascat, default value: 23


ASCAT requires other input files that are reused in each run. They include loci, alleles and, GC correction files. For more deteils on these input files, see ( TODO ) 

Running ASCAT
#############

`run_ascat.sh` calls `ascat.R` to run CNV analysis.  

The major steps of the ASCAT algorithm: 

1. Prepare High Throughput Sequencing (HTS)

- runs `allelecounter.exe` to collect allele counts at specific loci for normal and tumor samples.
- obtains B-allele Fraction (BAF) and LogR from the raw allele counts

2. Plot raw data 

- generates `png` files presenting the BAF and LogR for the normal and tumor samples

3. Correct LogR

- corrects logR of the tumor sample with genomic GC content

4. Plot corrected data

- generates `png` files presenting BAF and LogR for the normal and tumor samples after the GC correction

5. Run Allele Specific Piecewise Constant Fitting (ASPCF)

- it is a preprocessing step that fits piecewise constant regression functions to both the Log R and the BAF data at the same time. This method identifies regions (segments), which are genomics regions between two consecutive change points. Each segment has assigned a single LogR value and either one or two BAF values (a single BAF equal to 0.5 is assigned if the aberrant cells are discovered as balanced). The segmented data are saved to a `png` file. After this operation, partial results are saved to a `tsv` file containing the information about: LogR and BAF for both germline and somatic samples, LogR and BAF segmented for the tumor sample.

6. Run allele specific copy number analysis of tumors (ASCAT)

- determines estimated values of aberrant cell fractions, tumor ploidy, and allele specific copy number calls. Minor and major copy numbers for the segments are obtained. The results of this step are saved to a `tsv` file that contains start and end positions of the segments with the assigned minor and major copy numbers and their sum. A plot presenting ASCAT profiles of the sample is saved to a `png` file, and a plot showing ASCAT raw profiles. ASCAT evaluates the ploidy of the tumor cells and the fraction of abberant cells considering all their possible values, and finally selects the optimal solution. A graphical representation of these values is saved to a `png` file.

Others
######

In order to reproduce the obtained results, the `ascat` objects are stored in a `Rdata` file, which stores the following instances:

- `ascat.bc` -  an object returned from the `ascat.aspcf` function 
- `ascat.output` - an object returned from the `ascat.RunAscat` function 
- `QC` - an object that stores various ascat metrics returned from the `ascat.metrics` function