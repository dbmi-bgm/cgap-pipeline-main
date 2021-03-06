=============
mpileupCounts
=============

This step uses ``granite mpileupCounts`` (https://github.com/dbmi-bgm/granite) to create a ``.rck`` (Read Count Keeper) file from a ``bam`` input file. This is a pre-requisite step for calling *de novo* mutations.

* CWL: granite-mpileupCounts.cwl


Requirements
++++++++++++

A ``bam`` file and a reference ``fasta`` file must be provided. The step also takes in a file containing a list of genomic regions (that collectively covers the whole genome), to specify regions to run in parallel.


Output
++++++

The output ``.rck`` file contains read pileup counts information for every genomic position, stratified by allele (REFerence vs ALTernate), strand (ForWard vs ReVerse), and type (SNV, INSertion, DELetion).
The ``.rck`` file is a tab-delimited text file and can be compressed and indexed with tabix.

A few lines from an example ``.rck`` file is shown below:

::

  #CHR   POS   COVERAGE   REF_FW   REF_RV   ALT_FW   ALT_RV   INS_FW   INS_RV   DEL_FW   DEL_REV
  13     1     23         0        0        11       12       0        0        0        0
  13     2     35         18       15       1        1        0        0        0        0
