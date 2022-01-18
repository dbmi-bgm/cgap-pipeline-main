========================================
Joint Calling Annotation and Fisher Test
========================================

These optional metaworkflows use workflows from the CGAP's Upstream Sentieon Pipeline and SNV Germline Pipeline to generate and annotate a jointly called ``vcf`` and carry out statistics (including a `Fisher's Exact Test <https://en.wikipedia.org/wiki/Fisher%27s_exact_test#>`_) used for viewing in the ``HiGlass`` genome browser.

The ``joint_calling_gvcf_sentieon_plus_annot.json`` metaworkflow (https://github.com/dbmi-bgm/cgap-pipeline-main/tree/main/metaworkflows) makes use of both CGAP Pipelines, beginning with  ``g.vcf`` files and producing both a jointly called ``vcf`` file and an annotated file for ``HiGlass`` viewing.

The ``joint_calling_annot.json`` metaworkflow (https://github.com/dbmi-bgm/cgap-pipeline-SNV-germline) takes a jointly called ``vcf`` file as input and produces an annotated file for ``HiGlass`` viewing using workflows contained solely within the CGAP SNV Germline Pipeline. Apart from the joint calling step, these two metaworkflows are identical.

GVCFtyper
---------

This step generates a jointly called ``vcf`` file from ``g.vcf`` input files. See the following page for up-to-date information on the ``Sentieon GVCFtyper`` step.

:doc:`GVCFtyper step <sentieon_joint_calling-step-GVCFtyper>`

* CWL: sentieon-GVCFtyper.cwl

Multiallelic Variant Splitting and VEP Annotation
-------------------------------------------------

This step takes the jointly called ``vcf`` file and splits multiallelic variants before annotating all variants using ``VEP``. For more information about this step, see the following page, but note that for this workflow the depth threshold is ignored by running with ``DP`` of 0:

:doc:`VEP step </Pipelines/Downstream/SNV_germline/Pages/SNV_germline-step-vep>`

* CWL: workflow_vep-annot_plus_vcf-integrity-check.cwl

VCF Reformatting, Proband Calculations and Fisher's Exact Test
--------------------------------------------------------------

This step uses ``portal_reformat_vcf.py`` from https://github.com/dbmi-bgm/cgap-scripts/ alongside ``higlass_joint_parser.py`` from https://github.com/dbmi-bgm/cgap-pipeline-snv-germline/ to determine the worst consequence transcript for each variant, score the consequence as ``HIGH``, ``MODERATE``, ``LOW`` or ``MODIFIER`` impact, determine allele frequency in the probands (cases), and calculate a Fisher's Exact test for each variant comparing the probands to gnomAD.

* CWL: workflow_refomat_jc_vcf_fisher.cwl

Requirements
++++++++++++

A ``vcf`` file that has multiallelic variants split between lines and has been annotated with ``VEP`` including at least one of the gnomAD databases (v2, v3, or both). Also requires a ``txt`` list of probands (cases) for calculation of population allele frequency.

Parameters
++++++++++

``higlass_joint_parser.py`` requires the user to supply either ``v2``, ``v3``, or both (e.g., ``v2 v3``) for the Fisher's Exact Test calculations (``-g`` parameter). The Fisher's Exact Test will be calculated using the allele count (``AC``) and allele number (``AN``) separately for each gnomAD database supplied.

Calculations
++++++++++++

Consequence severity is calculated given the dictionary ranking present in ``portal_reformat_vcf.py`` and ``higlass_joint_parser.py``. The worst consequence transcript for each variant is flagged in ``portal_reformat_vcf.py`` and the category ``HIGH``, ``MODERATE``, ``LOW``, or ``MODIFIER`` is added to the variant in ``higlass_joint_parser.py``.

In ``higlass_joint_parser.py``, ``AC_proband``, ``AN_proband``, and ``AF_proband`` are also calculated for each variant, given the list of probands provided. For the Fisher's exact test, ``AC_proband`` (the number of alternative alleles in the proband population) and ``AN_proband`` (the total number of proband alleles genotyped at that position) are compared to ``AN`` and ``AC`` from either gnomAD v2 and/or gnomAD v3. For the Fisher's Exact Test, the calculation is as follows:

::

    gnomAD_dict = {"v2": "gnomADe2_", "v3": "gnomADg_"}
    gnomAD_base = gnomAD_dict[gnomAD_version] #gnomAD_version is v2 or v3 as supplied by user
    gnomAD_alt = int(dict[gnomAD_base+"AC"])
    gnomAD_ref = int(dict[gnomAD_base+"AN"]) - gnomAD_alt
    proband_alt = int(dict["AC_proband"])
    proband_ref = int(dict["AN_proband"]) - proband_alt

    oddsratio, pvalue = fisher_exact([[proband_alt, proband_ref], [gnomAD_alt, gnomAD_ref]], alternative='greater')

``pvalue`` is then converted to ``-log10p`` and attached to the variant.

The code above is simplified from ``higlass_joint_parser.py`` given that there are a few edge cases that needed to be accounted for in gnomAD v2. The gnomAD v2 database was originally called on ``hg19`` and has been lifted over to ``hg38``, resulting in a small number of variants that have multiple values in the gnomAD v2 field. This is due to liftover assigning two positions in ``hg19`` to the same position in ``hg38``. We account for this by parsing for the *most rare* allele given both the ``AC`` and ``AN`` in gnomAD v2 at that position in attempts to avoid a false negative at that position.

For a variant with gnomAD v2 values of ``AC=4&24``, ``AN=1000&10000``, we calculate ``AF`` as 4/1000 = 0.004 and 24/10000 = 0.0024 and we assign this variant the gnomAD v2 values of ``AC=24,AN=10000`` given that the ``AF`` of 0.0024 is more rare than 0.004.

Output
++++++

This step produces a joint called ``vcf`` with limited annotations pertaining to what is required by ``HiGlass``. These include the consequence level of the worst transcript for the variant, the ``AC``, ``AN``, and ``AF`` for the probands, and the gnomAD databases, as well as the results of the Fisher's Exact Tests that were conducted. All other data is removed from the ``INFO`` field to reduce the load on the ``HiGlass`` viewer. All genotype data is also removed to anonymize the data and reduce the load on the ``HiGlass`` viewer.
