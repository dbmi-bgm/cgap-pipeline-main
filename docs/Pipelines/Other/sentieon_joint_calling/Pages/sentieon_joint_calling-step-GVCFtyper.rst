=========
GVCFtyper
=========

This step uses Sentieon ``GVCFtyper`` algorithm to jointly call and genotype single nucleotide variants (SNVs) and small INDELs.

* CWL: sentieon-GVCFtyper.cwl


Requirements
++++++++++++

Requires input file(s) in ``g.vcf`` format generated through GATK ``HaplotypeCaller`` algorithm.


Parameters
++++++++++

To mirror our SNV Germline processing, which uses a ``--standard-min-confidence-threshold-for-calling`` default of ``10`` in the GATK ``GenotypeGVCFs`` step, we set the following parameters to run Sentieon ``GVCFtyper``.

1. ``--call_conf`` is set to ``10``
2. ``--emit_conf`` is set to ``10``
3. ``--emit_mode`` is set to ``variant``


Output
++++++

This step creates an output ``vcf`` file that stores jointly genotyped variants for all samples that are called together.


References
++++++++++

`Sentieon GVCFtyper <https://support.sentieon.com/manual/usages/general/#gvcftyper-algorithm>`__.
`GATK HaplotypeCaller <https://gatk.broadinstitute.org/hc/en-us/articles/5358864757787-HaplotypeCaller>`__.
`GATK GenotypeGVCFs <https://gatk.broadinstitute.org/hc/en-us/articles/5358906861083-GenotypeGVCFs>`__.
