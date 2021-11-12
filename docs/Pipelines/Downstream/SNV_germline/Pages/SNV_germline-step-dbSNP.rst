=================
dbSNP rsID update
=================

This step uses ``parallel_dbSNP_ID_fixer.sh`` to run ``dbSNP_ID_fixer.py`` and update dbSNP rsIDs in a sample ``vcf`` file's ID column. The output ``vcf`` file is checked for integrity.

* CWL: workflow_parallel_dbSNP_ID_fixer_plus_vcf-integrity-check.cwl

Requirements
++++++++++++

Must be run on sample ``vcf`` following bcftools norm since it only allows one variant per line in the sample ``vcf``.

Output
++++++

This process follows the following rules:

  1. Variants in the sample ``vcf`` are matched to the reference dbSNP ``vcf`` by CHROM, POS, REF, and ALT columns.
  2. All rsIDs in the sample ``vcf`` ID column are discarded and replaced by whatever is found in the reference dbSNP ``vcf``.
  3. Given a known bug where bcftools norm leaves an erroneous rsID at multiallelic sites, this will sometimes result in the removal of an rsID to be replaced by nothing ``.``.
  4. When multiple dbSNP rsIDs exist for a single CHROM, POS, REF, and ALT in the dbSNP reference ``vcf``, we have chosen to include them all, each separated by ``;``.  In our analysis, we looked up numerous examples where there were multiple rsIDs that appeared to be for the same variant.  In some cases one had been chosen as a parent to which the others were merged, but in other cases, we found no link between two rsIDs for variants that appear to be identical.  gnomAD from The Broad Institute (https://gnomad.broadinstitute.org/help) mentions similar issues with dbSNP within their database, so we have chosen to include all possible rsIDs for a given variant at this stage.
  5. If a sample ``vcf`` has a non-rsID within the ID field, this is not discarded. It will appear first in the ``;``-delimited list of any and all rsIDs found to match that variant in the reference dbSNP ``vcf``.

An example of how these rules are followed with various inputs is found below:

.. image:: ../../../../images/dbSNP_reference_table.png

For more details, see https://cgap-annotations.readthedocs.io/en/latest/variants_sources.html#dbsnp