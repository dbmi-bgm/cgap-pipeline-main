=====================================
Part 1. Manta-Based SV Identification
=====================================


Manta
+++++

This step carries out SV identification using ``Manta`` through the script ``manta.sh`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline).

* CWL: workflow_manta_integrity-check.cwl

Input
-----

Input files are sequence alignment files in ``bam`` format, generated from either of the `WGS Upstream pipelines <https://cgap-pipeline-master.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_. Analysis ready ``bam`` files can also be provided by the user.

Running Manta
-------------

``manta.sh`` carries out ``Joint Diploid Sample Analysis`` when more than one sample is provided and ``Single Diploid Sample Analysis`` when run with only the proband.

``manta.sh`` identifies Deletions (SVTYPE=DEL), Duplications (SVTYPE=DUP), Insertions (SVTYPE=INS), and Inversion/Translocations (SVTYPE=BND).

A ``callRegions`` region file containing the main chromosome names limits the ``Manta`` run to chr1-chr22, chrX and chrY.

The script ``convertInversion.py`` (https://github.com/Illumina/manta/) is also called within ``manta.sh`` to separate (SVTYPE=INV) from other translocations (SVTYPE=BND). The output file is a ``vcf`` file which is checked for integrity.
