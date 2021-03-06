=====
ASCAT
=====

This step calls Copy Number Variants (CNVs) in Tumor-Normal paired samples with the ``ASCAT`` algorithm using ``ascat.R`` script (https://github.com/dbmi-bgm/cgap-pipeline-SV-somatic).

* CWL: workflow_ascat.cwl

Input
#####

The user should provide the following files and parameters:

- a ``bam`` file containing aligned sequencing reads of a tumor sample
- a ``bam`` file containing aligned sequencing reads of a normal sample
- a ``gender`` parameter for the gender information, accepted values are XX (female) or XY (male)
- a ``nthreads`` parameter for the number of threads to run ASCAT, default value: 23

The algorithm also requires additional reference files that include loci, allele and, GC correction files. For more details on these files, see (https://cgap-annotations.readthedocs.io/en/latest/ascat.html)

Running ASCAT
#############

``run_ascat.sh`` calls ``ascat.R`` to run the CNV analysis.

The major steps of the ``ASCAT`` algorithm:

1. Calculate allele counts and allele fractions

  - runs ``alleleCount`` to collect allele counts at specific loci for normal and tumor samples
  - obtains B-allele Fraction (BAF) and LogR from the raw allele counts

2. Plot raw data

  - generates ``png`` files presenting the BAF and LogR for the normal and tumor samples

3. Correct LogR

  - corrects LogR of the tumor sample with genomic GC content

4. Plot corrected data

  - generates ``png`` files presenting BAF and LogR for the normal and tumor samples after the GC correction

5. Run Allele Specific Piecewise Constant Fitting (ASPCF)

  - it is a preprocessing step that fits piecewise constant regression to both the Log R and the BAF data at the same time. This method identifies regions (segments), which are genomics regions between two consecutive change points. Each segment has assigned a single LogR value and either one or two BAF values (a single BAF equal to 0.5 is assigned if the aberrant cells are discovered as balanced). The segmented data are saved to a ``png`` file. After this operation, partial results are saved to a ``tsv`` file containing the information about: LogR and BAF for both germline and somatic samples, LogR and BAF segmented for the tumor sample.

6. Run allele specific copy number analysis of tumors

  - determines estimated values of aberrant cell fractions, tumor ploidy, and allele specific copy number calls. Minor and major copy numbers for the segments are obtained. The results of this step are saved to a ``tsv`` file that contains start and end positions of the segments with the assigned minor and major copy numbers and their sum. A plot presenting ASCAT profiles of the sample is saved to a ``png`` file, and a plot showing ASCAT raw profiles. ASCAT evaluates the ploidy of the tumor cells and the fraction of abberant cells considering all their possible values, and finally selects the optimal solution. A graphical representation of these values is saved to a ``png`` file.

Others
######

In order to reproduce the obtained results, some of the ``ascat`` objects are saved in an ``Rdata`` file, which stores the following objects:

- ``ascat.bc`` -  an object returned from the ``ascat.aspcf`` function
- ``ascat.output`` - an object returned from the ``ascat.RunAscat`` function
- ``QC`` - an object that stores various ascat metrics returned from the ``ascat.metrics`` function
