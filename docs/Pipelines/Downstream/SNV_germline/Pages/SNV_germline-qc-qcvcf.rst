===================
VCF Quality Control
===================


Overview
++++++++

To evaluate the quality of a ``vcf`` file, different metrics are calculated using granite ``qcVCF``.
The software calculates both sample-based, as well as, family-based statistics.

The metrics currently available for sample are:

  - Variant types distribution
  - Base substitutions
  - Transition-transversion ratio
  - Heterozygosity ratio
  - Depth of coverage (GATK)
  - Depth of coverage (raw)

The metrics currently available for family are:

  - Mendelian errors in trio

For each sample, ancestry and sex are also predicted using peddy [1]_.
The predicted values allow to identify errors in sample labeling, contaminations events, and other errors that can occur during handling and processing of the sample.


Definitions
+++++++++++

Variant Types Distribution
--------------------------

Total number of variants classified by type as:

  - **DEL**\ etion  (*ACTG>A or ACTG>\**)
  - **INS**\ ertion  (*A>ACTG or \*>ACTG*)
  - **S**\ ingle-\ **N**\ ucleotide **V**\ ariant  (*A>T*)
  - **M**\ ulti-\ **A**\ llelic **V**\ ariant  (*A>T,C*)
  - **M**\ ulti-\ **N**\ ucleotide **V**\ ariant  (*AA>TT*)

Base Substitutions
------------------

Total number of SNVs classified by the type of substitution (e.g., C>T).

Transition-Transversion Ratio
-----------------------------

Ratio of transitions to transversions in SNVs.
It is expected to be [2, 2.20] for WGS and [2.6, 3.3] for WES.

Heterozygosity Ratio
--------------------

Ratio of heterozygous to alternate homozygous variants.
It is expected to be [1.5, 2.5] for WGS analysis.
Heterozygous and alternate homozygous sites are counted by variant type.

Depth of Coverage
-----------------

Average depth of all variant sites called in the sample.

Depth of coverage (GATK) is calculated based on ``DP`` values as assigned by GATK.
Depth of coverage (raw) is calculated based on raw read counts calculated directly from the bam file.

Mendelian Errors in Trio
------------------------

Variant sites in proband that are not consistent with mendelian inheritance rules based on parent genotypes.
Mendelian errors are counted by variant type and classified based on genotype combinations in trio as:

+------------+------------+-----------+---------------------+
| Proband    | Father     | Mother    | Type                |
+============+============+===========+=====================+
| 0/1        | 0/0        | 0/0       | *de novo*           |
+------------+------------+-----------+---------------------+
| 0/1        | 1/1        | 1/1       | Error               |
+------------+------------+-----------+---------------------+
| 1/1        | 0/0        | [any]     | Error               |
+------------+------------+-----------+---------------------+
| 1/1        | [any]      | 0/0       | Error               |
+------------+------------+-----------+---------------------+
| 1/1 \| 0/1 | ./.        | [any]     | Missing in parent   |
+------------+------------+-----------+---------------------+
| 1/1 \| 0/1 | [any]      | ./.       | Missing in parent   |
+------------+------------+-----------+---------------------+

Ancestry and Sex Prediction
---------------------------

Ancestry prediction is based on projection onto the thousand genomes principal components.
Sex is predicted by using the genotypes observed outside the pseudo-autosomal region on X chromosome.


References
++++++++++

`granite <https://github.com/dbmi-bgm/granite>`__.
`peddy <https://github.com/brentp/peddy>`__.

---------------------------

.. [1] Pedersen and Quinlan, Who’s Who? Detecting and Resolving Sample Anomalies in Human DNA Sequencing Studies with Peddy, The American Journal of Human Genetics (2017), http://dx.doi.org/10.1016/j.ajhg.2017.01.017
