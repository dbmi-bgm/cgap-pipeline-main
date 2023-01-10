======================
Overview - CNV Somatic
======================

The CGAP Pipelines module for somatic Copy Number Variants (CNVs) (https://github.com/dbmi-bgm/cgap-pipeline-SV-somatic) identifies, annotates, and filters CNVs starting from analysis-ready ``bam`` files to produce final sets of calls in ``vcf`` format.

CNVs are a class of large genomic variants that result in a change in copy number, including deletions (also referred to as losses) and duplications (also referred to as gains).
CNVs are identified by algorithms that search for unexpected differences in sequencing coverage.

The pipeline is mostly based on the CNV calling algorithm ASCAT, and calls variants from Whole Genome Sequencing (WGS) Tumor-Normal paired samples.
It can receive the initial analysis-ready ``bam`` files from either of the `CGAP Upstream modules <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.

**Note**: If the user is providing ``bam`` files as input, the files must be aligned to **hg38/GRCh38** for compatibility with the annotation steps.


Docker Image
#############

The Dockerfiles provided in this GitHub repository can be used to build public docker images.
If built through ``cgap-pipeline-utils`` ``pipeline_deploy`` command (https://github.com/dbmi-bgm/cgap-pipeline-utils), private ECR images will be created for the target AWS account.

The ``ascat`` image is primarily for **CNV identification**. This image contains (but is not limited to) the following software packages:

- R (4.1.0)
- `ascat <https://github.com/VanLoo-lab/ascat>`__ (3.0.0)
- `alleleCount <https://anaconda.org/bioconda/cancerit-allelecount>`__ (4.3.0)


Pipeline Steps
##############

.. toctree::
   :maxdepth: 4

   Pages/ascat


References
##########

`ASCAT <https://github.com/VanLoo-lab/ascat>`__.
