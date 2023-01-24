===============================================================
Part 3. Structural Variants Filtering and Secondary Annotations
===============================================================


Annotation Filtering and ``SVTYPE`` Selection
+++++++++++++++++++++++++++++++++++++++++++++

This multi-step workflow filters structural variant (SV) calls based on annotations (i.e, functional relevance, genomic location, allele frequency) and ``SVTYPE``.
It is mostly based on granite software.
The output ``vcf`` file is checked for integrity to ensure the format is correct and the file is not truncated.

* CWL: workflow_granite-filtering_SV_selector_plus_vcf-integrity-check.cwl

Requirements
------------

The input is a single annotated ``vcf`` file with the SV calls.
The annotations must include genes and transcripts information (VEP) and allele frequency from gnomAD SV (Sansa).

Gene list
---------

The gene list step uses granite to clean VEP annotations for transcripts that are not mapping to any gene of interest (not present in the CGAP Portal).
This step does not remove any variants, but only modifies VEP annotations.

Inclusion List
--------------

The inclusion list step uses granite to filter-in exonic and functionally relevant variant based on VEP annotations.
This step removes a large number of SVs from the initial call set.

Exclusion List
--------------

The exclusion list step uses granite to filter-out common variants based on gnomAD SV population allele frequency (``AF`` > 0.01).
Variants without gnomAD SV annotations are retained.

SV Type Selection
------------------

This step uses ``SV_type_selector.py`` script to filter out unwanted SV types.
Currently only deletions (DEL) and duplications (DUP) are retained.

Output
------

The output is a filtered ``vcf`` file with fewer entries than the input ``vcf`` file.
The content of the remaining entries is identical to the input (no information added or removed) minus the information removed by the gene list step.


20 Unrelated Filtering
++++++++++++++++++++++

This step uses ``20_unrelated_SV_filter.py`` script to identify common and artifactual SVs in 20 unrelated individuals and filter them out.
SV calls for each of the 20 unrelated individuals were generated with Manta (see: https://cgap-annotations.readthedocs.io/en/latest/unrelated_references.html).

* CWL: workflow_20_unrelated_SV_filter_plus_vcf-integrity-check.cwl

Requirements
------------

The input is a single annotated ``vcf`` file with the SV calls, alongside a ``tar`` archive of the ``vcf`` files with the SV calls for the 20 unrelated individuals.
This step currently only work with DEL and DUP (which are provided to the ``SVTYPE`` argument), although the ``vcf`` files can contain other type of variants.

Matching and Filtering
----------------------

When comparing SV calls from the input ``vcf`` file to the calls for an unrelated ``vcf`` file, the following logic applies to define a match:

  1. ``SVTYPE`` must match
  2. breakpoints at 5' end must be +/- 50 bp from each other
  3. breakpoints at 3' end must be +/- 50 bp from each other
  4. SVs must reciprocally overlap by a minimum of 80%

This produces a filtered ``vcf`` file that only contains SVs shared by a maximum of n individuals.
The default is currently n = 1, such that SVs shared by 2 or more of the 20 unrelated individuals are filtered out.

Output
------

The output is a filtered ``vcf`` file containing fewer entries compared to the input ``vcf`` file.
The variants that remain after filtering will receive an additional annotation, ``UNRELATED=n``, where n is the number of matches found within the 20 unrelated SV calls.


Secondary Annotation
++++++++++++++++++++

This workflow runs a series of scripts to add additional annotations to the SV calls in ``vcf`` format:

  - ``liftover_hg19.py`` (https://github.com/dbmi-bgm/cgap-scripts) to add lift-over coordinates for breakpoint locations for **hg19/GRCh37** genome build
  - ``SV_worst_and_locations.py`` to add information for breakpoint locations relative to impacted transcripts and the most severe consequence from VEP annotations
  - ``SV_cytoband.py`` to add Cytoband information for the breakpoint locations

``SV_worst_and_locations.py`` also implement some filtering and can result in fewer variants in the resulting ``vcf`` that is eventually checked for integrity.

**Note**: These scripts only work on DEL and DUP calls. Inversions (INV), break-end (BND), and insertions (INS) are not supported.

* CWL: workflow_SV_secondary_annotation_plus_vcf-integrity-check.cwl

Requirements
------------

This workflow requires a single ``vcf`` file with the SV calls that went through **Annotation Filtering and** ``SVTYPE`` **Selection**.
It also requires:

  - The **hg38/GRCh38** to **hg19/GRCh37** chain file for lift-over (https://cgap-annotations.readthedocs.io/en/latest/liftover_chain_files.html#hg38-grch38-to-hg19-grch37)
  - The **hg38/GRCh38** Cytoband reference file from UCSC (https://cgap-annotations.readthedocs.io/en/latest/variants_sources.html#cytoband)

Both the Cytoband annotation and the lift-over step require the ``END`` tag in the INFO field in the ``vcf`` file.

Annotation and Possible Filtering
---------------------------------

1. For ``liftover_hg19.py``, three lines are added to the header:

::

  ##INFO=<ID=hg19_chr,Number=.,Type=String,Description="CHROM in hg19 using LiftOver from pyliftover">
  ##INFO=<ID=hg19_pos,Number=.,Type=Integer,Description="POS in hg19 using LiftOver from pyliftover (converted back to 1-based)">
  ##INFO=<ID=hg19_end,Number=1,Type=Integer,Description="END in hg19 using LiftOver from pyliftover (converted back to 1-based)">

The data associated with these tags are also added to the INFO field of the ``vcf`` file for qualifying variants using the following criteria:

  * For the lift-over process to **hg19/GRCh37** coordinates, variants with successful conversions at both breakpoints will include data for the ``hg19_chr`` and both ``hg19_pos`` (breakpoint 1) and ``hg19_end`` (breakpoint 2) tags in the INFO field. If the conversion fails (e.g., if the coordinates do not have a corresponding location in **hg19/GRCh37**), the tags and any lift-over information will not be included in the output. Note that each breakpoint is treated separately, so it is possible for a variant to have data for ``hg19_chr`` and ``hg19_pos``, but not ``hg19_end``, or ``hg19_chr`` and ``hg19_end``, but not ``hg19_pos``
  * Given that pyliftover does not convert ranges, the single-point coordinate in **hg38/GRCh38** corresponding to each variant CHROM and POS (or ``END``) are used as query, and the **hg19/GRCh37** coordinate (result) will also be a single-point coordinate

2. For ``SV_worst_and_locations.py``, three new fields are added to the ``CSQ`` tag in INFO field initially created by VEP. These are:

  * ``Most_severe``, which will have a value of ``1`` if the transcript is the most severe, and will otherwise be blank
  * ``Variant_5_prime_location``, which gives the location for breakpoint 1 relative to the transcript (options below)
  * ``Variant_3_prime_location``, which gives the location for breakpoint 2 relative to the transcript (options below)

Options for the location fields include:
``Indeterminate``, ``Upstream``, ``Downstream``, ``Intronic``, ``Exonic``, ``5_UTR``, ``3_UTR``, ``Upstream_or_5_UTR``, ``3_UTR_or_Downstream``, or ``Within_miRNA``.

Additionally, for each variant this step removes annotated transcripts that do not possess one of the following biotypes: ``protein_coding``, ``miRNA``, or ``polymorphic_pseudogene``.
If after this cleaning a variant no longer has any annotated transcripts, that variant is also filtered out of the ``vcf`` file.

3. For ``SV_cytoband.py``, the following two lines are added to the header:

::

  ##INFO=<ID=Cyto1,Number=1,Type=String,Description="Cytoband for SV start (POS) from hg38 cytoBand.txt.gz from UCSC">
  ##INFO=<ID=Cyto2,Number=1,Type=String,Description="Cytoband for SV end (INFO END) from hg38 cytoBand.txt.gz from UCSC">

Each variant will receive a ``Cyto1`` annotation which corresponds to the Cytoband position of breakpoint 1 (which is POS in the ``vcf``), and a ``Cyto2`` annotation which corresponds to the Cytoband position of breakpoint 2 (which is ``END`` in the INFO field).

Output
------

The output is an annotated ``vcf`` file where secondary annotations are added to qualifying variants as described above.
Some variants may be additionally filtered out as described.


Length Filtering
++++++++++++++++

This step uses ``SV_length_filter.py`` to remove the largest SVs from the calls in the ``vcf`` file.
The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_SV_length_filter_plus_vcf-integrity-check.cwl

Requirements
------------

This workflow requires a single ``vcf`` file with the SV calls and a parameter to define the maximum length allowed for the SVs.

Filtering
---------

Currently we are filtering-out events larger than 10 Mb that we observed represent artifacts for the algorithm.

Output
------

This is the final ``vcf`` file that is ingested into the CGAP Portal.


VCF Annotation Cleaning
+++++++++++++++++++++++

This step uses ``SV_annotation_VCF_cleaner.py`` script to remove most of VEP annotations to create a smaller ``vcf`` file for HiGlass visualization.
This improves the loading speed in the genome browser.
The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_SV_annotation_VCF_cleaner_plus_vcf-integrity-check.cwl

Requirements
------------

This workflow expects the final ``vcf`` file that is ingested into the CGAP Portal as input.

Cleaning
--------

VEP annotations are removed from the ``vcf`` file and the REF and ALT fields are simplified using the ``SV_annotation_VCF_cleaner.py`` script.

Output
------

The output is a modified version of the final ``vcf`` file that is ingested into the CGAP Portal, that has been cleaned for the HiGlass genome browser.
This file is also ingested into the CGAP Portal but only used for visualization.


References
++++++++++

`granite <https://github.com/dbmi-bgm/granite>`__.
