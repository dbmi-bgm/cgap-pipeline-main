====================
Downstream Pipelines
====================

Downstream pipelines use analysis-ready ``bam`` files to generate filtered lists of variants in ``vcf`` format.
These ``bam`` files are standard alignment files that have been further processed to eliminate duplicate reads and recalibrate base quality scores as described `here <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.


Germline
++++++++

Germline pipelines are designed to identify rare inherited variations in an individual's genome.
These mutations may be present in the individual's parents or may arise as new mutations in germ cells and be passed on as *de novo* mutations.

.. toctree::
   :maxdepth: 2

   SNV_germline/index-SNV_germline
   SV_germline/index-SV_germline
   CNV_germline/index-CNV_germline


Somatic
+++++++

Somatic pipelines are designed to identify somatic mutations, which are changes that occur in an individual's DNA during their lifetime and are present in certain cells only.
These mutations are often associated with cancer and can be identified using matched tumor-normal samples or tumor-only data in order to discover mutations that may be related to cancer development or progression.

.. toctree::
   :maxdepth: 2

   somatic_sentieon/index-somatic_sentieon
   SNV_somatic/index-SNV_somatic
   CNV_somatic/index-CNV_somatic
