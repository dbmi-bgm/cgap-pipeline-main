=================
Variant Filtering
=================

This step performs an annotation-based filtering of the variants in the input ``vcf``.

* CWL: workflow_granite-filtering_plus_vcf-integrity-check.cwl


Requirements
++++++++++++

The input is a single, annotated ``vcf`` file. Annotation must include VEP, ClinVar and SpliceAI.

This step can optionally use a panel of unrelated samples in ``.big`` format to filter-out variants with reads supporting an ALTernate allele in the panel. This option is currently not used in the pipeline.


Steps
+++++

The filtering step is composed of multiple intermediate steps and the output ``vcf`` file is checked for integrity to ensure the format is correct and the file is not truncated.

.. image:: ../../../../images/cgap_filtering_v20.png

Genelist
---------

This intermediate step uses ``granite geneList`` to clean VEP annotations for transcripts that are not mapping to any gene of interest (the current CGAP gene list is available `here`_). It is similar to VEP cleaning (below) but applies to genes rather than consequences. This step does not remove any variant and only modifies the VEP annotations.

.. _here: https://cgap-reference-file-registry.s3.amazonaws.com/84f2bb24-edd7-459b-ab89-0a21866d7826/GAPFI5MKCART.txt

Inclusion list
--------------

These intermediate steps use a ``granite`` function to filter-in exonic and functionally relevant variants based on VEP, ClinVar, and SpliceAI annotations. The ClinVar Inclusion list is applied separately and the variants are not cleaned and filtered further by VEP cleaning and Exclusion list.

Criteria for Inclusion list:

  - VEP: exonic and functionally relevant consequences, plus splice regions
  - ClinVar: Pathogenic, Likely Pathogenic, Conflicting Interpretation of Pathogenicity, and Risk Factor
  - SpliceAI: max delta score >= 0.2

VEP cleaning
------------

This intermediate step uses ``granite cleanVCF`` to clean VEP annotations and remove non-relevant consequences. The step eventually discards variants that remain with no VEP annotations.

Exclusion list
--------------

This intermediate step uses a ``granite`` function to filter-out common and shared variants based on gnomAD population allele frequency (AF > 0.01) and/or a panel of unrelated samples (optional, not used currently).

Merging
-------

This intermediate step merges the set of variants from ClinVar Inclusion list with the other set of fully-filtered variants. For variants that overlap between the two sets, the ClinVar Inclusion list variant is maintained to preserve the most complete set of annotations.

Output
++++++

The final output is a filtered ``vcf`` file containing a subset of variants from the initial ``vcf`` file. The information attached to filtered variants is the same as in the original variants, with the exception of VEP annotations that have been cleaned to remove non-relevant transcripts and consequences.
