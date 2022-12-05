====================
Downstream Pipelines
====================

Downstream pipelines begin from analysis ready ``bam`` files and end with filtered lists of variants.
An analysis ready ``bam`` undergoes some additional cleanup operations after the alignment to remove duplicate reads and recalibrate base quality scores.


Germline
++++++++

Germline pipelines focus on discovery of rare variants inherited from parents. These mutations can be already present in the parents, or can be acquired as *de novo* mutations in a germ cell in one of the parents.

.. toctree::
   :maxdepth: 2

   SNV_germline/index-SNV_germline
   SV_germline/index-SV_germline
   CNV_germline/index-CNV_germline

Somatic
+++++++

Somatic pipelines focus on discovery of somatic variants, often in matched tumor-normal samples.

.. toctree::
   :maxdepth: 2

   somatic_sentieon/index-somatic_sentieon
   SNV_somatic/index-SNV_somatic
   CNV_somatic/index-CNV_somatic
