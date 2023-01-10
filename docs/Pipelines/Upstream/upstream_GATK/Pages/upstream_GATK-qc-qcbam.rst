===================
BAM Quality Control
===================


Overview
++++++++

To evaluate the quality of a ``bam`` file, different metrics are calculated using the custom script ``bamqc.py``.

The metrics currently available are:

  - Mapping stats

      - Total reads
      - Reads with both mates mapped
      - Reads with one mate mapped
      - Reads with neither mate mapped

  - Read length
  - Coverage


Definitions
+++++++++++

Mapping Statistics
------------------

The number of reads (not alignments) are counted as the number of unique read pairs (i.e., if a read pair is mapped to multiple locations it is only counted once).


Coverage
--------

Coverage (=Depth of Coverage) is calculated as below:

::

    { (number of reads w/ both mates mapped) * (read length) * 2 + (number of reads w/ one mate mapped) * (read length) } / (effective genome size)


Here, the effective genome size is the number of non-N bases in the genome for WGS and an estimation of mappable space (exon and UTR regions) for WES.
