===============
HaplotypeCaller
===============


HaplotypeCaller for WGS
+++++++++++++++++++++++

This step uses GATK ``HaplotypeCaller`` to call SNVs and INDELs via local re-assembly of haplotypes for Whole Genome Sequencing (WGS) data.
The software creates a ``g.vcf`` file from the input ``bam`` file.

* CWL: gatk-HaplotypeCaller.cwl


HaplotypeCaller for WES
+++++++++++++++++++++++

This step uses GATK ``HaplotypeCaller`` to call SNVs and INDELs via local re-assembly of haplotypes for Whole Exome Sequencing (WES) data.
The software creates a ``g.vcf`` file from the input ``bam`` file.

To run ``HaplotypeCaller`` on exomes, we use a custom region file following GATK best practices for WES analysis (`reference <https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/deploying-gatk-best-practices-paper.pdf>`_).
We currently use a very permissive region file created for **hg38/GRCh38** to include all exons and UTR regions that are annotated in ensembl (https://cgap-annotations.readthedocs.io/en/latest/exome_regions.html).

* CWL: gatk-HaplotypeCaller_exome.cwl


References
++++++++++

`GATK HaplotypeCaller <https://gatk.broadinstitute.org/hc/en-us/articles/5358864757787-HaplotypeCaller>`__.
