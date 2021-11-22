=========
GVCFtyper
=========

This step uses Sentieon's `GVCFtyper <https://support.sentieon.com/manual/usages/general/#gvcftyper-algorithm>`_ to jointly call and genotype single nucleotide variants (SNVs) and small INDELs.

* CWL: sentieon-GVCFtyper.cwl


Requirements
++++++++++++

Must be run on input ``g.vcf`` files generated through ``HaplotypeCaller``.

Parameters
++++++++++

To mirror our SNV Germline Pipeline, which uses a GATK Best Practices ``--standard-min-confidence-threshold-for-calling`` default of 10 in the ``GenotypeGVCF`` step, we set the following parameters for ``GVCFtyper``.
1. ``--call_conf`` is set to ``10``
2. ``--call_conf`` is set to ``10``
3. ``--emit_mode`` is set to ``variant``

Output
++++++

This step creates an output ``vcf`` that has variants called across all input samples provided, and variants genotyped for each sample with sufficient data at that site.
