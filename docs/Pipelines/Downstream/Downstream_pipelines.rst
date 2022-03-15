====================
Downstream Pipelines
====================

Downstream pipelines begin from analysis ready ``bam`` files and end with filtered lists of variants.
An analysis ready ``bam`` undergoes some additional cleanup operations after the alignment to remove duplicate reads and recalibrate base quality scores.


Germline
++++++++

Germline pipelines focus on discovery of rare variants inherited from parents, either mutations already present in parents or *de novo* mutations acquired in a germ cell in one of the parent.

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
