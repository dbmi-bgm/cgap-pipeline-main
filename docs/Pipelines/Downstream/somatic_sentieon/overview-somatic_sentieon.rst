===========================
Overview - Somatic Sentieon
===========================

CGAP Pipeline Somatic Sentieon (https://github.com/dbmi-bgm/cgap-pipeline-somatic-sentieon) is our *license-based* option for calling variants from Tumor-Normal Whole Genome Sequencing (WGS) samples. The pipeline begins with a single ``bam`` file from a Tumor sample and a corresponding ``bam`` file from Normal (non-Tumor) tissue. Both ``bam`` files must be from the same individual, and they must be mapped to **hg38**. These ``bam`` files can be generated using either of the `CGAP WGS Upstream Pipelines <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_. The output of this pipeline is a ``vcf`` file that contains Single Nucleotide Variants (SNVs), short INsertions and DELetions (INDELs), and Structural Variants (SVs).

Docker Image
############

The Dockerfile provided in this GitHub repository can be used to build a public docker image, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils) a private ECR image will be created for the AWS account provided.

The image contains (but is not limited to) the following software packages:

- Sentieon (202112.01)
- samtools (1.9)

Pipeline Flow
#############

Our implementation offers a one step end-to-end solution to carry out a Tumor-Normal analysis using the Sentieon TNscope algorithm as described `here <https://support.sentieon.com/manual/TNscope_usage/tnscope/>`_. We are making use of a Panel of Normal (PON) ``vcf`` file generated from 20 unrelated UGRP samples as described here (https://cgap-annotations.readthedocs.io/en/latest/unrelated_references.html).
