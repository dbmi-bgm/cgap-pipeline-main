===================
Variant Annotation
===================

This step splits multi-allelic variants, re-aligns INDELs, removes variants that do not meet a read depth (``DP``) of 3 in at least one sample, and annotates variants for the input ``vcf`` file.
BCFtools is used for split and realignment, ``depth_filter.py`` (https://github.com/dbmi-bgm/cgap-scripts) is used to filter variants based on depth, and VEP (Variant Effect Predictor) is used for annotation along with several plug-ins and external data sources.

For more details on annotation sources used, see https://cgap-annotations.readthedocs.io/en/latest/variants_sources.html#vep

* CWL: workflow_vep-annot_plus_vcf-integrity-check.cwl


References
++++++++++

`ensembl-vep <https://github.com/Ensembl/ensembl-vep>`__.
`BCFtools <https://github.com/samtools/bcftools>`__.
