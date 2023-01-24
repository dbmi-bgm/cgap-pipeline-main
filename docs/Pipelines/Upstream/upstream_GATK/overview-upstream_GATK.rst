========================
Overview - Upstream GATK
========================

The CGAP Pipelines module for upstream processing with GATK (https://github.com/dbmi-bgm/cgap-pipeline-upstream-GATK) is our open-source solution for processing Whole Genome Sequencing (WGS) and Whole Exome Sequencing (WES) datasets.

The pipeline takes paired-end ``fastq`` files and produces analysis-ready ``bam`` files that can be used by any of the CGAP Pipelines downstream modules (e.g., SNV Germline and SV Germline).

The pipeline is based on **hg38/GRCh38** genome build and is optimized for 30x coverage for WGS data and 90x coverage for WES data.
It has been tested with WGS data up to 80-90x coverage and WES data ranging from 20 to 200x coverage.

Both the WES and WGS configurations are mostly based on bwa and GATK4, following `GATK best practices <https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels->`_.

**Note**: If the user wants to provide ``cram`` files as input, they must first be converted to paired-end ``fastq`` files using the CGAP Pipelines base module (https://github.com/dbmi-bgm/cgap-pipeline-base).


Docker Image
############

The Dockerfiles provided in this GitHub repository can be used to build public docker images.
If built through ``cgap-pipeline-utils`` ``pipeline_deploy`` command (https://github.com/dbmi-bgm/cgap-pipeline-utils), private ECR images will be created for the target AWS account.

The ``upstream_gatk`` image is primarily for **reads alignment and post-processing of the aligned reads**.
This image contains (but is not limited to) the following software packages:

- gatk (4.2.6.1)
- picard (2.26.11)
- samtools (1.9)
- bwa (0.7.17)


Pipeline Flow
#############

The overall flow of the pipeline is shown below:

.. image:: ../../../images/upstream_GATK.png


Pipeline Steps
##############

.. toctree::
   :maxdepth: 2

   steps-upstream_GATK


References
##########

`bwa <https://github.com/lh3/bwa>`__.
`GATK4 <https://gatk.broadinstitute.org/hc/en-us>`__.
