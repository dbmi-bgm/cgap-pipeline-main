=======================
Overview - SNV Germline
=======================

The CGAP Pipeline for Germline Single Nucleotide Variants (SNVs) (https://github.com/dbmi-bgm/cgap-pipeline-SNV-germline) processes Whole Genome Sequencing (WGS) and Whole Exome Sequencing (WES) data starting from analysis ready ``bam`` files, and produces ``g.vcf`` and ``vcf`` files containing SNVs and short INsertions and DELetions (INDELs) as output.

The CGAP Pipeline SNV Germline supports analysis ready ``bam`` files generated by mapping raw reads from both WGS and WES sequencing runs to **hg38**.
It can receive the initial ``bam`` file(s) from either of the `CGAP Upstream Pipelines <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.

The WGS configuration is designed for a trio analysis with proband diagnosed with a likely monogenic disease. It is optimized for data with 30x coverage and has been tested with data up to 80-90x coverage. It can also be run in proband-only, and family modes.
The WES configuration is a recent extension of the WGS pipeline, which allows for the processing of WES data. We are currently optimizing for 90x coverage and testing from 20x-200x.

Both the WES and WGS configurations of the CGAP Pipeline SNV Germline are mostly based on ``gatk4`` (https://gatk.broadinstitute.org/hc/en-us), ``granite`` (https://github.com/dbmi-bgm/granite), ``ensembl-vep`` (https://github.com/Ensembl/ensembl-vep) and ``bamsnap`` (https://github.com/dbmi-bgm/bamsnap). The pipelines perform joint-sample variant calling within a family, perform annotation and filtering, call *de novo* mutations and compound heterozygous variants, and generate snapshot images for the filtered set of variants. ``vcf`` files are checked for integrity using ``vcftools`` ``vcf-validator`` at the end of any step during which they are created or modified.


Docker Images
#############

The Dockerfile provided in this GitHub repository can be used to build a public docker image, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils) a private ECR image will be created for the provided AWS account.

The ``snv_germline_gatk`` image is primarily for **genotyping variants**. This image contains (but is not limited to) the following software packages:

- gatk (4.2.6.1)

The ``snv_germline_granite`` image is primarily for **filtering and annotating variants**. This image contains (but is not limited to) the following software packages:

- granite (0.2.0)
- samtools (1.9)

The ``snv_germline_misc`` image is primarily for **pipeline utilities**. This image is one of the few that does not use the base image provided in the CGAP Pipeline Main repository due to requiring an older version of python. This image contains (but is not limited to) the following software packages:

- python (3.6.8)
- bamsnap-cgap (0.3.0)
- peddy (0.4.7)
- granite (0.2.0)

The ``snv_germline_tools`` image is primarily for **pipeline utilities**. This image contains (but is not limited to) the following software packages:

- vcftools (0.1.17, 954e607)
- bcftools (1.11)

The ``snv_germline_vep`` image is primarily for **annotating variants**. This image contains (but is not limited to) the following software packages:

- vep (101)


Pipeline Flow
#############

The overall flow of the pipeline looks as below:

.. image:: ../../../images/bioinfo-snv-indel-flow-v22-20210526.png


Pipeline Parts and Runtimes
###########################

The CGAP SNV Germline Pipeline is primarily used for variant calling following GATK (Genome Analysis Toolkit) Best Practice. Variants are then annotated and filtered.

The run time of the different steps are summarized in the following diagram:

.. image:: ../../../images/SNV_germline.png


Pipeline Steps
##############

.. toctree::
   :maxdepth: 1

   Pages/SNV_germline-step-haplotypecaller
   Pages/SNV_germline-step-combinegvcfs
   Pages/SNV_germline-step-genotypegvcf
   Pages/SNV_germline-step-mpileup
   Pages/SNV_germline-step-rcktar
   Pages/SNV_germline-step-samplegeno
   Pages/SNV_germline-step-vep
   Pages/SNV_germline-step-filtering
   Pages/SNV_germline-step-denovo
   Pages/SNV_germline-step-comhet
   Pages/SNV_germline-step-dbSNP
   Pages/SNV_germline-step-hg19LO-hgvsg
   Pages/SNV_germline-step-bamsnap


Pipeline Validation
###################

.. toctree::
  :maxdepth: 2

  validation-SNV_germline
