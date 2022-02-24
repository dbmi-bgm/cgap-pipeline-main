=========================================
Part 1. BIC-seq2 Based CNV Identification
=========================================

BIC-seq2
++++++++

This workflow contains three steps that take a ``bam`` file input and produce a ``txt`` output table of regions partitioned by observed and expected sequencing coverage, as calculated by ``BIC-seq2``, to identify potential CNVs.

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

``BIC-seq2 Seg`` carries out segmentation of the genome into regions based on the number of observed and expected reads following the normalization step above. The output of ``BIC-seq2 Seg`` is a ``txt`` table with genomic regions, the number of observed and expected reads with those regions, the log2.copyRatio between observed and expected reads, and pvalues that indicate how significant the log2.copyRatio change is from the expected null of 0.

Reformatting BIC-seq2 Output to VCF
+++++++++++++++++++++++++++++++++++
