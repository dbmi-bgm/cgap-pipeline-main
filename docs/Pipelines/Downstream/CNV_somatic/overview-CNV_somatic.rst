======================
Overview - CNV Somatic
======================

The CGAP Pipeline for Somatic Copy Number Variants (CNVs) (https://github.com/dbmi-bgm/cgap-pipeline-SV-somatic) identifies CNVs starting from short read sequencing alignment files (``bam``) and produces ``vcf`` files as output.

CNVs are a class of large genomic variants that result in a change in copy number, including deletions (also referred to as losses) and duplications (also referred to as gains). CNVs are identified by algorithms that seek out aberrant differences in sequencing coverage.

The CGAP Somatic CNV Pipeline is mostly based on the CNV calling algorithm ``ASCAT`` (https://github.com/VanLoo-lab/ascat), and calls variants from Whole Genome Sequencing (WGS) Tumor-Normal paired samples. It can receive the initial analysis ready ``bam`` files from either of the `CGAP WGS Upstream Pipelines <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.


Docker Image
#############

The Dockerfiles provided in this GitHub repository can be used to build public docker images, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils), private ECR images will be created for the provided AWS account.

The ``ascat`` image is primarily for **CNV identification**. This image contains (but is not limited to) the following software packages:

- R (4.1.0)
- `ascat <https://github.com/VanLoo-lab/ascat>`__ (3.0.0)
- `alleleCount <https://anaconda.org/bioconda/cancerit-allelecount>`__ (4.3.0)


Pipeline Steps
##############

.. toctree::
   :maxdepth: 4

   Pages/ascat
