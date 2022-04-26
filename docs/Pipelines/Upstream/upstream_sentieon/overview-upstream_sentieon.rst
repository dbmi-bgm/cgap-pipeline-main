============================
Overview - Upstream Sentieon
============================

CGAP Pipeline Upstream Sentieon (https://github.com/dbmi-bgm/cgap-pipeline-upstream-sentieon) is our *license-based* option for processing Whole Genome Sequencing (WGS) and Whole Exome Sequencing (WES) datasets. The pipeline begins with paired ``fastq`` files and produces analysis ready ``bam`` files (mapped reads) which can be supplied to numerous CGAP downstream pipelines, including the SNV Germline and SV Germline Pipelines. We use **hg38** as the reference genome for read mapping. If the user wishes to provide ``cram`` files as input, these can first be converted to ``fastq`` files using the CGAP Pipeline Base module.

The CGAP Pipeline Upstream Sentieon supports both WGS and WES input files.
The pipeline is based on `Sentieon <https://www.sentieon.com/>`_ implementation of ``bwa`` and ``gatk4`` and follows GATK Best Practice (https://gatk.broadinstitute.org/hc/en-us/articles/360035535912-Data-pre-processing-for-variant-discovery). Sentieon offers a faster and more computationally efficient implementation of the original algorithms.


Docker Image
############

The Dockerfile provided in this GitHub repository can be used to build a public docker image, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils) a private ECR image will be created for the AWS account provided.

The ``upstream_sentieon`` image contains (but is not limited to) the following software packages:

- Sentieon (202112.01)
- samtools (1.9)

Pipeline Flow
#############

Our implementation offers a one step end-to-end solution to process raw sequencing data, producing an analysis ready ``bam`` file as described `here <https://support.sentieon.com/manual/DNAseq_usage/dnaseq/#step-by-step-usage-for-dnaseq-reg>`_.
