==================
Upstream Pipelines
==================

Upstream pipelines are designed to take raw sequencing data as paired ``fastq`` files, align the reads to the reference genome and prepare the resulting analysis ready ``bam`` file for use in variant calling.
An analysis ready ``bam`` undergo some additional cleanup operations after the alignment to remove duplicate reads and recalibrate base quality scores.


.. toctree::
   :maxdepth: 2

   upstream_GATK/index-upstream_GATK
   upstream_sentieon/index-upstream_sentieon
