===============
HaplotypeCaller
===============


HaplotypeCaller for WGS
+++++++++++++++++++++++

This step uses ``GATK HaplotypeCaller`` to call germline SNVs and INDELs via local re-assembly of haplotypes for Whole Genome Sequencing (WGS) data.
The software creates a ``g.vcf`` file from the input ``bam`` file.

* CWL: gatk-HaplotypeCaller.cwl


HaplotypeCaller for WES
+++++++++++++++++++++++

This step uses ``GATK HaplotypeCaller`` to call germline SNVs and INDELs via local re-assembly of haplotypes for Whole Exome Sequencing (WES) data.
The software creates a ``g.vcf`` file from the input ``bam`` file.
When run on exomes, ``HaplotypeCaller`` makes use of a region file following GATK best practices for WES analysis (see: https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/deploying-gatk-best-practices-paper.pdf).
To account for all possible scenario, we use a very permissive region file created for hg38 to include all exons and UTR regions annotated in ensembl (see: https://cgap-annotations.readthedocs.io/en/latest/exome_regions.html).

* CWL: gatk-HaplotypeCaller_exome.cwl
