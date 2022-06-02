=======================================
Part 1. Filtering and Splitting the VCF
=======================================


Somatic Sentieon VCF Splitter
+++++++++++++++++++++++++++++

This step filters and splits the initial input ``vcf``, resulting in four output files. This is carried out through ``somatic_sentieon_vcf_splitter.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SNV-somatic).

* CWL: workflow_somatic_filter_split_plus-vcf-integrity-check.cwl

Input
-----

One ``vcf`` file containing information from the Tumor-Normal analysis generated using the `CGAP Somatic Sentieon Pipeline <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Downstream/somatic_sentieon/index-somatic_sentieon.html>`_.

Filtering and output
--------------------

During the CGAP Somatic Sentieon Pipeline, variants are identified in the tumor sample and the normal sample for a single individual, they are also compared to a Panel of Normals (PON). If a given tumor variant is of high quality, does not appear in the germline genome (the normal sample),  or in the PON in more than 2 samples, it might receive ``PASS`` in the filter column.

This produces four output files that contain only the ``PASS`` variants, as follows:

1. ``vcf`` file with all ``PASS`` variants of all types

2. ``vcf`` file with all ``PASS`` SNVs

3. ``vcf`` file with all ``PASS`` INDELs

4. ``vcf`` file with all ``PASS`` SVs in bnd format

Each ``vcf`` file is also checked for integrity individually.


SV bnd conversion
+++++++++++++++++

This step converts the SV ``vcf`` file created in the previous step into the ``bedpe`` format for visualization using ``SV_bnd_converter.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SNV-somatic).

**UNDER DEVELOPMENT**
