=========================================
Part 1. BIC-seq2 Based CNV Identification
=========================================

BIC-seq2
++++++++

This workflow contains three steps that take a ``bam`` file as input and produce a ``txt`` output table of regions partitioned by observed and expected sequencing coverage, as calculated by ``BIC-seq2``, to identify potential CNVs.

* CWL: workflow_BICseq2_map_norm_seg.cwl

Input
-----

Input file is a sequence alignment file in ``bam`` format, generated from either of the `CGAP WGS Upstream Pipelines <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_. An analysis ready ``bam`` file can also be provided by the user, but it must currently be mapped to **hg38** with 150 bp paired-end reads.

Generating BIC-seq2 Seq Files
-----------------------------

First, read position (``seq``) files are generated using ``map.sh``, which calls ``samtools`` to view and filter reads based on final mapping quality (MAPQ) score and read length. These ``seq`` files are the main input for ``BIC-seq2 Norm``. During this step, the fragment size of the library is also calculated using ``samtools`` and ``picard``.

Running BIC-seq2 Norm
---------------------

Once the ``seq`` files are created, they can be run through ``BIC-seq2 Norm`` using ``norm.sh``. First, the fragment size calculated during the previous step is checked to be between 150 bp and 1500 bp. The workflow will fail if the fragment size is too large or too small.

It is important to note that ``BIC-seq2`` is designed to work with a unique mappability file that is specific to the genome versions and the read length of the input ``bam`` file. For information on how we generated our current mappability file (**hg38** and 150 bp), see: https://cgap-annotations.readthedocs.io/en/latest/bic-seq2_mappability.html.

With the appropriate mappability file, ``BIC-seq2 Norm`` will run and produce normalized sequencing coverage across the mappable genome. Given the expectation for diploid sequencing data, the ``BIC-seq2`` algorithm is only run for the autosomes.

Running BIC-seq2 Seg
--------------------

``BIC-seq2 Seg`` carries out segmentation of the genome into regions based on the number of observed and expected reads following the normalization step above. The output of ``BIC-seq2 Seg`` is a ``txt`` table with genomic regions, the number of observed and expected reads with those regions, the *log2.copyRatio* between observed and expected reads, and *pvalues* that indicate how significant the *log2.copyRatio* change is from the expected null of 0.

Reformatting BIC-seq2 Output to ``vcf``
+++++++++++++++++++++++++++++++++++++++

This workflow parses and filters the ``txt`` output table of genomic regions with coverage information from ``BIC-seq2`` and generates a basic ``vcf`` output file with SVTYPE of DEL or DUP and genotype for a single sample. The workflow makes use of ``bic_seq2_vcf_formatter.py`` to carry out the conversion. The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_BICseq2_to_vcf_plus_vcf-integrity-check.cwl

Calling DEL or DUP
------------------

The following parameters are used to call a significant DEL or DUP:

1. ``'-p','--pvalue'``: the *pvalue* below which a region could be called as a DEL or DUP; currently 0.05
2. ``'-d','--log2_min_dup'``: positive value (*log2.copyRatio*) above which a duplication is called; currently 0.2
3. ``'-e','--log2_min_del'``: negative value (*log2.copyRatio*) below which a deletion is called; currently (-)0.2

A DEL is called if ``pvalue`` and  ``log2_min_del`` are both true. A DUP is called if ``pvalue`` and ``log2_min_dup`` are both true. If only one of the ``pvalue`` or the ``log2_min`` for the variant type is true, the region is not reported.

Genotyping DEL or DUP
---------------------

If a variant qualifies as a DEL or DUP above, it must next be genotyped. The following parameters are used:

1. ``'-u','--log2_min_hom_dup'``: positive value (*log2.copyRatio*) above which a homozygous or high copy number duplication is called; currently 0.8
2. ``'-l','--log2_min_hom_del'``: negative value (*log2.copyRatio*) below which a homozygous deletion is called; currently (-)3.0

If a DEL is valid, but displays a *log2.copyRatio* between ``log2_min_del`` and ``log2_min_hom_del``, it will be genotyped as heterozygous ``0/1``, otherwise it will be genotyped as homozygous ``1/1``.

If a DUP is valid, but displays a *log2.copyRatio* between ``log2_min_dup`` and ``log2_min_hom_dup``, it will be genotyped as heterozygous ``0/1``, otherwise it will be genotyped as unknown ``./.``.

We currently do not provide a true genotype for DUPs with *log2.copyRatio* > ``log2_min_hom_dup``, because unlike DELs, proband-only CNV analysis cannot conclude the phase of duplications. For example, with two extra copies, each parent could provide one copy ``1/1`` or one parent could provide two copies ``2/0``.
