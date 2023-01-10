=====
ASCAT
=====

This step calls copy number variants (CNVs) in Tumor-Normal paired samples with the ASCAT algorithm using ``ascat.R`` script.

* CWL: ascat.cwl


Input
#####

The user should provide the following files and parameters:

- Analysis-ready ``bam`` file containing aligned sequencing reads for a Tumor sample
- Analysis-ready ``bam`` file containing aligned sequencing reads for a Normal sample
- ``gender`` parameter for the gender information, accepted values are XX (female) or XY (male)
- ``nthreads`` parameter for the number of threads to run ASCAT; default value is 23

The algorithm also requires additional reference files that include loci, allele and, GC correction files.
For more details on these files, see (https://cgap-annotations.readthedocs.io/en/latest/ascat.html).


Running ASCAT
#############

``run_ascat.sh`` calls ``ascat.R`` to run the CNV analysis.

The major steps of the ``ASCAT`` algorithm are:

1. Calculate allele counts and allele fractions

  - Runs ``alleleCount`` to collect allele counts at specific loci for Normal and Tumor samples
  - Obtains B-allele Fraction (BAF) and LogR from the raw allele counts

2. Plot raw data

  - Generates ``png`` files presenting the BAF and LogR for the Normal and Tumor samples

3. Correct LogR

  - Corrects LogR of the Tumor sample with genomic GC content

4. Plot corrected data

  - Generates ``png`` files presenting BAF and LogR for the Normal and Tumor samples after the GC correction

5. Run Allele Specific Piecewise Constant Fitting (ASPCF)

  - It is a preprocessing step that fits piecewise constant regression to both the LogR and the BAF data at the same time. This method identifies regions (segments), which are genomics regions between two consecutive change points. Each segment has assigned a single LogR value and either one or two BAF values (a single BAF equal to 0.5 is assigned if the aberrant cells are discovered as balanced). The segmented data are saved to a ``png`` file. After this operation, partial results are saved to a ``tsv`` file containing the information about: LogR and BAF for both germline and somatic samples, LogR and BAF segmented for the Tumor sample.

6. Run allele specific copy number analysis of tumors

  - Determines estimated values of aberrant cell fractions, tumor ploidy, and allele specific copy number calls. Minor and major copy numbers for the segments are obtained. The results of this step are saved to a ``tsv`` file that contains start and end positions of the segments with the assigned minor and major copy numbers and their sum. A plot presenting ASCAT profiles of the sample is saved to a ``png`` file, and a plot showing ASCAT raw profiles. ASCAT evaluates the ploidy of the tumor cells and the fraction of abberant cells considering all their possible values, and finally selects the optimal solution. A graphical representation of these values is saved to a ``png`` file.


Others
######

In order to reproduce the obtained results, some of the ASCAT objects are saved in an ``Rdata`` file, which stores the following objects:

- ``ascat.bc`` -  an object returned from the ``ascat.aspcf`` function
- ``ascat.output`` - an object returned from the ``ascat.RunAscat`` function
- ``QC`` - an object that stores various ascat metrics returned from the ``ascat.metrics`` function


References
##########

`ASCAT <https://github.com/VanLoo-lab/ascat>`__.
