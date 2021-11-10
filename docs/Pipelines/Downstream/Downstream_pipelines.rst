====================
Downstream Pipelines
====================

Downstream pipelines begin from ``bam`` files (containing reads mapped back to the reference genome) and end with filtered lists of variants.

Germline
++++++++

Germline pipelines focus on variants that were inherited from parents or acquired *de novo* during development. This is in contrast to somatic pipelines, often used in cancer research that compare healthy tissue to cells obtained from somatic cells that have undergone mutations throughout the life of an individual.

.. toctree::
   :maxdepth: 2

   SNV_germline/index-SNV_germline
   SV_germline/index-SV_germline

Somatic
+++++++

Somatic pipelines (both SV/CNV and SNV) are currently under development by the CGAP Bioinformatics Team.
