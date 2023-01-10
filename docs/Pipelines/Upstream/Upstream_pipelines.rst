==================
Upstream Pipelines
==================

Upstream pipelines start from raw paired-end sequencing data as ``fastq`` files, align the reads to the reference genome and produce analysis-ready ``bam`` files for use in downstream variant calling pipelines.
Analysis-ready ``bam`` files are standard alignment files that undergo additional processing to remove duplicate reads and recalibrate base quality scores.


.. toctree::
   :maxdepth: 2

   upstream_GATK/index-upstream_GATK
   upstream_sentieon/index-upstream_sentieon
