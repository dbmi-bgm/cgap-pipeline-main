===================================
Part 1. BICseq2 CNVs Identification
===================================


BICseq2
+++++++

This workflow runs BICseq2 algorithm to identify potential copy number variants (CNVs).
It is divided in three parts, it starts from a ``bam`` file and produces a ``txt`` output table of genomic regions partitioned by observed and expected sequencing coverage.

* CWL: workflow_BICseq2_map_norm_seg.cwl

Input
-----

The input is an analysis-ready ``bam`` file, generated from either of the `CGAP Upstream modules <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_.
The ``bam`` file can also be provided by the user.
Currently only 150 bp paired-end sequencing mapped to **hg38/GRCh38** is supported.

Generating BICseq2 ``seq`` Files
--------------------------------

Reads position files (``seq``) are generated using ``map.sh``.
The script uses Samtools to filter reads based on final mapping quality score (MAPQ) and length.
These ``seq`` files are the main input for the normalization step (``BICseq2-norm``).
The fragment size for the library is also calculated using Samtools and Picard.

BICseq2-norm
------------

Once the ``seq`` files are created, they can run through ``BICseq2-norm`` (normalization) using ``norm.sh`` script.
The fragment size calculated for the ``seq`` files must be between 150 bp and 1500 bp.
The workflow will fail if the fragment size is too large or too small.

It is important to note that BICseq2 is designed to work with a unique mappability file that is specific to a genome version and a read length.
For information on how we generated our current mappability file (**hg38/GRCh38** and 150 bp), see: https://cgap-annotations.readthedocs.io/en/latest/bic-seq2_mappability.html.

With the appropriate mappability file, ``BICseq2-norm`` produces normalized sequencing coverage across the mappable genome.
Given the expectation for diploid genome, BICseq2 algorithm can only apply to autosomes.

BICseq2-seg
-----------

``BICseq2-seg`` (segmentation) partitions the genome into regions based on the number of observed and expected reads produced by the normalization step.
The output is a ``txt`` table with genomic regions, the number of observed and expected reads within those regions, the *log2.copyRatio* between observed and expected reads, and *pvalues* that indicate how significant the *log2.copyRatio* change is from the expected null of 0.


Reformatting BICseq2 Output to ``vcf``
+++++++++++++++++++++++++++++++++++++++

This workflow uses ``bic_seq2_vcf_formatter.py`` script to filter the output table from BICseq2 and convert the CNVs calls in ``vcf`` format, adding ``SVTYPE`` (DEL or DUP) and genotype information.
The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_BICseq2_to_vcf_plus_vcf-integrity-check.cwl

Calling DEL or DUP
------------------

The following logic is used to classify BICseq2 calls as deletions (DEL) or duplications (DUP):

1. ``'-p','--pvalue'``: the *pvalue* below which a region could be called as a deletions or duplications; currently 0.05
2. ``'-d','--log2_min_dup'``: positive value (*log2.copyRatio*) above which a duplication is called; currently 0.2
3. ``'-e','--log2_min_del'``: negative value (*log2.copyRatio*) below which a deletion is called; currently (-)0.2

A DEL is called if ``pvalue`` and  ``log2_min_del`` are both true.
A DUP is called if ``pvalue`` and ``log2_min_dup`` are both true.
If only one of the ``pvalue`` or the ``log2_min`` for the variant type is true, the region is not reported.

Genotyping DEL or DUP
---------------------

If a variant qualifies as a DEL or DUP, it must be genotyped. The following logic applies:

1. ``'-u','--log2_min_hom_dup'``: positive value (*log2.copyRatio*) above which a homozygous or high copy number duplication is called; currently 0.8
2. ``'-l','--log2_min_hom_del'``: negative value (*log2.copyRatio*) below which a homozygous deletion is called; currently (-)3.0

If a DEL is valid, but displays a *log2.copyRatio* between ``log2_min_del`` and ``log2_min_hom_del``, it will be genotyped as heterozygous ``0/1``.

If a DUP is valid, but displays a *log2.copyRatio* between ``log2_min_dup`` and ``log2_min_hom_dup``, it will be genotyped as heterozygous ``0/1``.

We currently do not provide a true genotype for DUPs with *log2.copyRatio* > ``log2_min_hom_dup``, because unlike DELs, proband-only CNV analysis cannot conclude the phase of duplications.
For example, with two extra copies, each parent could provide one copy ``1/1`` or one parent could provide two copies ``2/0``. In this case we will genotype the variant as unknown ``./.``.


References
++++++++++

`BICseq2 <https://www.math.pku.edu.cn/teachers/xirb/downloads/software/BICseq2/BICseq2.html>`__.
