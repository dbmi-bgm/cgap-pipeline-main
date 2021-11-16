============
GenotypeGVCF
============

This step uses ``GATK GenotypeGVCF`` to perform joint genotyping on one or more samples pre-called with ``HaplotypeCaller``.
The software creates a ``vcf`` file from a ``g.vcf`` input file.
The output ``vcf`` file is checked for integrity to ensure the format is correct and the file is not truncated.

* CWL: workflow_gatk-GenotypeGVCFs_plus_vcf-integrity-check.cwl
