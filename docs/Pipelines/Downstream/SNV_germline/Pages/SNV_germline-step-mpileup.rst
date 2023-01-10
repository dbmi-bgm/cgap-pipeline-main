=============
mpileupCounts
=============

This step uses granite ``mpileupCounts`` to create a ``rck`` file from a ``bam`` input file.
This is a pre-requisite step for calling *de novo* mutations.

* CWL: granite-mpileupCounts.cwl


Requirements
++++++++++++

The command takes a ``bam`` file and a genome reference ``fasta`` file as input.
To optimize performance, it is also possible to specify a file containing a list of genomic regions to parallelize the analysis.


Output
++++++

The output ``rck`` file contains read pileup counts information for every genomic position, stratified by allele (REFerence vs ALTernate), strand (ForWard vs ReVerse), and type (SNV, INSertion, DELetion).
The ``rck`` file is then compressed and indexed with tabix.

A few lines from an example ``rck`` file is shown below:

::

  #CHR   POS   COVERAGE   REF_FW   REF_RV   ALT_FW   ALT_RV   INS_FW   INS_RV   DEL_FW   DEL_REV
  13     1     23         0        0        11       12       0        0        0        0
  13     2     35         18       15       1        1        0        0        0        0


References
++++++++++

`granite <https://github.com/dbmi-bgm/granite>`__.
