================================================
Part 1. Manta Structural Variants Identification
================================================


Manta
+++++

This step executes the ``manta.sh`` script, which runs the Manta algorithm to identify potential structural variations (SVs) in the input data.
The output is a ``vcf`` file, which is then checked for integrity to confirm that the format is correct and the file is complete.

* CWL: workflow_manta_integrity-check.cwl

Input
-----

The script takes analysis-ready ``bam`` file(s), generated from either of the `CGAP Upstream modules <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.
The input file(s) can also be provided directly by the user.

Running Manta
-------------

Manta executes a *Joint Diploid Sample Analysis* when more than one sample is provided, and a *Single Diploid Sample Analysis* when run for a single sample (i.e., proband-only).
The algorithm identifies deletions (``SVTYPE=DEL``), duplications (``SVTYPE=DUP``), insertions (``SVTYPE=INS``), and inversion/translocations (``SVTYPE=BND``).

A ``callRegions`` region file containing a list of chromosome names limits the search to canonical and sex chromosomes (i.e., chr1-chr22, chrX and chrY).

The script ``convertInversion.py`` (https://github.com/Illumina/manta) is also run to separate (``SVTYPE=INV``) from other translocations (``SVTYPE=BND``).


References
++++++++++

`Manta <https://github.com/Illumina/manta>`__.
