========================
Overview - Upstream GATK
========================

CGAP Pipeline Upstream GATK (https://github.com/dbmi-bgm/cgap-pipeline-upstream-GATK) is our open source option for processing Whole Genome Sequencing (WGS) and Whole Exome Sequencing (WES) datasets. The pipeline begins with paired ``fastq`` files and produces analysis ready ``bam`` files (mapped reads) which can be supplied to numerous CGAP downstream pipelines, including the SNV Germline and SV Germline Pipelines. We use **hg38** as the reference genome for mapping reads. If the user wishes to provide ``cram`` files as input, these can first be converted to ``fastq`` files using the CGAP Pipeline Base module (https://github.com/dbmi-bgm/cgap-pipeline-base).

The CGAP Pipeline Upstream GATK supports both WGS and WES input files. The WGS configuration is optimized for data with 30x coverage and has been tested with data up to 80-90x coverage.
The WES configuration is a recent extension of the WGS pipeline, which allows for the processing of WES data. We are currently optimizing for 90x coverage and testing from 20x-200x.

Both the WES and WGS configurations of the CGAP Pipeline Upstream GATK are mostly based on ``bwa`` (https://github.com/lh3/bwa) and ``gatk4`` and follow `GATK Best Practice <https://gatk.broadinstitute.org/hc/en-us/articles/360035535912-Data-pre-processing-for-variant-discovery>`_.
Users can select the correct pipeline configuration for their input data through the use of the corresponding *MetaWorkflow* (e.g., ``WES_upstream_gatk_proband.json`` for a single sample of WES data or ``WGS_upstream_gatk.json`` for a trio (mother, father, and proband) with WGS library preparation).


Docker Image
############

The Dockerfile provided in this GitHub repository can be used to build a public docker image, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils) a private ECR image will be created for the AWS account provided.

The ``upstream_gatk`` image is primarily for **mapping reads and identifying variants**. This image contains (but is not limited to) the following software packages:

- gatk (4.2.6.1)
- picard (2.26.11)
- samtools (1.9)
- bwa (0.7.17)


Pipeline Flow
#############

The overall flow of the pipeline looks as below:

.. image:: ../../../images/bioinfo-snv-indel-flow-v22-20210526.png


Pipeline Parts and Runtimes
###########################

The CGAP Upstream GATK Pipeline is primarily used for read mapping from raw sequencing data, following GATK Best Practice.

The run time of the different steps are summarized in the following diagram:

.. image:: ../../../images/upstream_GATK.png


Pipeline Steps
##############

.. toctree::
   :maxdepth: 2

   steps-upstream_GATK
