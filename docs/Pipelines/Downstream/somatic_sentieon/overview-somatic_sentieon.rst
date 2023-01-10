===========================
Overview - Somatic Sentieon
===========================

The CGAP Pipelines module for somatic variant calling with Sentieon (https://github.com/dbmi-bgm/cgap-pipeline-somatic-sentieon) is our *license-based* option for calling Single Nucleotide Variants (SNVs), short Insertions and Deletions (INDELs), and Structural Variants (SVs) for Whole Genome Sequencing (WGS) Tumor-Normal paired data.
The pipeline starts from matching analysis-ready ``bam`` files for a Tumor and a corresponding Normal (non-Tumor) tissue for the same individual.
It can receive the initial ``bam`` files from either of the `CGAP Upstream modules <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.
The output of the pipeline is a ``vcf`` file with the variant calls that are unique of the Tumor.

**Note**: If the user is providing ``bam`` files as input, the files must be aligned to **hg38/GRCh38** for compatibility with the annotation steps.


Docker Image
############

The Dockerfiles provided in this GitHub repository can be used to build public docker images.
If built through ``cgap-pipeline-utils`` ``pipeline_deploy`` command (https://github.com/dbmi-bgm/cgap-pipeline-utils), private ECR images will be created for the target AWS account.

The image contains (but is not limited to) the following software packages:

- Sentieon (202112.01)
- samtools (1.9)


Pipeline Flow
#############

Our implementation offers a one step end-to-end solution to run a Tumor-Normal analysis using the Sentieon ``TNscope`` algorithm as described `here <https://support.sentieon.com/manual/TNscope_usage/tnscope/>`_.
We are using of a Panel of Normal (PON) ``vcf`` file generated from 20 unrelated samples from The Utah Genome Project (UGRP) as described here (https://cgap-annotations.readthedocs.io/en/latest/unrelated_references.html).


References
##########

`Sentieon <https://www.sentieon.com>`__.
