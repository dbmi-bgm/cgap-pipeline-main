===================
VCF Quality Control
===================


Overview
++++++++

To evaluate the quality of a ``vcf`` file, different metrics are calculated using granite ``SVqcVCF``.

The metrics currently available are:

  - Variant types distribution per sample
  - Total variant counts per sample


Definitions
+++++++++++

Variant Types Distribution
--------------------------

Total number of variants classified by type as:

  - **DEL**\ etion (``SVTYPE=DEL``)
  - **DUP**\ lication (``SVTYPE=DUP``)
  - Total variants (``SVTYPE=DEL`` + ``SVTYPE=DUP``)

Variants are only counted if the sample has a non-reference genotype (``0/1`` or ``1/1``).


References
++++++++++

`granite <https://github.com/dbmi-bgm/granite>`__.
