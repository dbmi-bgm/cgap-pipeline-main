=====================
Steps - Upstream GATK
=====================


Alignment
+++++++++

This step uses bwa ``mem`` algorithm to align a set of paired-end ``fastq`` files to the reference genome.
We currently use build **hg38/GRCh38**, more information `here <https://cgap-annotations.readthedocs.io/en/latest/hg38_genome.html>`_.
The output ``bam`` file is checked for integrity to ensure there is a properly formatted header and the file is not truncated.

* CWL: workflow_bwa-mem-to-bam_no_unzip_plus_integrity-check.cwl


Add Read Groups
+++++++++++++++

This step uses ``AddReadGroups.py`` (https://github.com/dbmi-bgm/cgap-scripts) to add read groups information to the input ``bam`` file based on lanes and flow-cells identifiers.
The script extracts read groups information from read names and tags the reads accordingly.
Unlike Picard ``AddOrReplaceReadGroups``, which assumes a single read group throughout the file, the script can handle files that contains a mix of multiple lanes and flow-cells.
The output ``bam`` file is checked for integrity to ensure there is a properly formatted header and the file is not truncated.

* CWL: workflow_add-readgroups_plus_integrity-check.cwl


Merge BAMs
++++++++++

This step uses Samtools ``merge`` to merge multiple ``bam`` files when data comes in replicates.
If there are no replicates, this step is skipped.
The output ``bam`` file is checked for integrity to ensure there is a properly formatted header and the file is not truncated.

* CWL: workflow_merge-bam_plus_integrity-check.cwl


Mark Duplicates
+++++++++++++++

This step uses Picard ``MarkDuplicates`` to detect and mark PCR duplicates.
It creates a duplicate-marked ``bam`` file and a report with duplicate stats.
The output ``bam`` file is checked for integrity to ensure there is a properly formatted header and the file is not truncated.

* CWL: workflow_picard-MarkDuplicates_plus_integrity-check.cwl


Sort BAM
++++++++

This step uses Samtools ``sort`` to sort the input ``bam`` file by genomic coordinates.
The output ``bam`` file is checked for integrity to ensure there is a properly formatted header and the file is not truncated.

* CWL: workflow_sort-bam_plus_integrity-check.cwl


Base Recalibration Report (BQSR)
++++++++++++++++++++++++++++++++

This step uses GATK ``BaseRecalibrator`` to create a base quality score recalibration report for the input ``bam`` file.

* CWL: gatk-BaseRecalibrator.cwl


Apply BQSR and Indexing
+++++++++++++++++++++++

This step uses GATK ``ApplyBQSR`` to apply the base quality score recalibration report to the input ``bam`` file.
This step creates a recalibrated ``bam`` file and a corresponding index.
The output ``bam`` file is checked for integrity to ensure there is a properly formatted header and the file is not truncated.

* CWL: workflow_gatk-ApplyBQSR_plus_integrity-check.cwl


References
##########

`bwa <https://github.com/lh3/bwa>`__.
`GATK & Picard Tools <https://gatk.broadinstitute.org/hc/en-us/articles/5358824293659--Tool-Documentation-Index>`__.
`Samtools <http://www.htslib.org>`__.
