===============================================================
Part 3. Copy Number Variant Filtering and Secondary Annotations
===============================================================


Initial Annotation Filtering
++++++++++++++++++++++++++++

The multi-step workflow carries out ``granite`` filtering, coding filtering, gnomAD SV allele frequency filtering and CNV type selection.

* CWL: workflow_granite-filtering_SV_selector_plus_vcf-integrity-check.cwl

Requirements
------------

A single, annotated CNV ``vcf`` file is required as input. The annotations should include annotation of transcripts through ``VEP`` and gnomAD SV allele frequency through ``sansa``.

The filtering step is composed of multiple steps and the output ``vcf`` file is checked for integrity to ensure the format is correct and the file is not truncated.

Genelist
---------

The genelist step uses ``granite geneList`` to clean VEP annotations for transcripts that are not mapping to any gene of interest (not present on the CGAP Portal). This step does not remove any variants, but only modifies the VEP annotation.

Inclusion List
--------------

The Inclusion list steps use ``granite`` function to filter-in exonic and functionally relevant variant based on VEP annotations. This step removes a large number of CNVs from the initial call set.

Exclusion List
--------------

The Exclusion list step uses ``granite`` function to filter-out common variants based on gnomAD SV population allele frequency (AF > 0.01). Variants without gnomAD SV annotations are retained.

CNV Type Selection
------------------

This step uses ``SV_type_selector.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to filter out unwanted CNV types. Currently only DEL and DUP are retained.

Output
------

The output is a filtered ``vcf`` file containing a lot fewer entries compared to the input ``vcf``. The content of the remaining entries are identical to the input (no additional information added or removed). The resulting ``vcf`` file is checked for integrity.


20 Unrelated Filtering
++++++++++++++++++++++

This step uses ``20_unrelated_SV_filter.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to assess common and artefactual CNVs in 20 unrelated samples and allows us to filter them from our sample ``vcf`` file. The 20 unrelated reference files (CNV ``vcf`` files) were each generated using ``BIC-seq2`` for a single diploid individual (see: https://cgap-annotations.readthedocs.io/en/latest/20_unrelated.html#cnv-pipeline-bic-seq2).

* CWL: workflow_20_unrelated_SV_filter_plus_vcf-integrity-check.cwl

Requirements
------------

A single, annotated CNV ``vcf`` file is expected as input alongside a ``tar`` folder of 20 unrelated CNV ``vcf`` files. This step cannot currently assess CNVs other than DELs and DUPs (which are provided to the SVTYPE argument), although the ``vcf`` files can contain these variants.

Matching and Filtering
----------------------

When comparing variants from the sample CNV ``vcf`` file to an unrelated CNV ``vcf`` file, the following matching criteria are currently in place:

  1. SVTYPE must match
  2. Breakpoints at 5' end must be +/- 50 bp from each other
  3. Breakpoints at 3' end must be +/- 50 bp from each other
  4. CNVs must reciprocally overlap by a minimum of 80%

The matching step is carried out as follows:

  1. The sample CNV ``vcf`` file is compared pair-wise to each of 20 unrelated CNV ``vcf`` reference files and CNVs that match between are written out from the sample CNV ``vcf`` file.
  2. This results in 20 "matched" CNV ``vcf`` files, where each file contains the subset of CNVs from the sample file that overlapped a single individual from the 20 unrelated references.
  3. The "matched" CNV ``vcf`` files are read into a dictionary that counts the number of times each sample CNV is found (max of 1 time per 20 files = 20 matches).

The filtering step reads through the sample CNV ``vcf`` file a final time and writes a filtered CNV ``vcf`` file that only contains CNVs that matched a maximum of n individuals. The default is currently n = 1, such that sample CNVs that match 2 or more of the 20 unrelated individuals are filtered out.

Output
------

The output is a filtered ``vcf`` file containing a lot fewer entries compared to the input ``vcf``.  The variants that remain after filtering will receive an additional annotation, ``UNRELATED=n``, where n is the number of matches found within the 20 unrelated CNV ``vcf`` files.


Secondary Annotation
++++++++++++++++++++

This workflow contains a series of short steps that add additional annotations to the existing ``vcf`` file, before the output ``vcf`` file is checked for integrity. This workflow makes use of ``liftover_hg19.py`` (https://github.com/dbmi-bgm/cgap-scripts) alongside ``SV_worst_and_locations.py`` and ``SV_cytoband.py`` (both from https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to create annotations pertaining to the breakpoint locations in **hg19**, the breakpoint locations relative to the transcript they impact (e.g., Exonic, Intronic, etc.), the most severe consequence from ``VEP`` annotation, and the cytoband(s) the breakpoints overlap with. The resulting ``vcf`` file might include slighlty fewer variants given a filtration step conducted in ``SV_worst_and_locations.py``.

* CWL: workflow_SV_secondary_annotation_plus_vcf-integrity-check.cwl

Requirements
------------

This annotation step is present in Part 3 because the three python scripts used are designed to work only on DELs and DUPs (no INV, BND, INS) and because there is a possibility of filtering out a small number of variants during ``SV_worst_and_locations.py``. Both the cytoband annotation step and the liftover step also require the END field in the INFO block. This workflow requires a single CNV ``vcf`` file that has undergone **Initial Annotation Filtering** step (which selects for DELs and DUPs), the **hg38** to **hg19** chain file for liftover (http://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz), and the **hg38** cytoband reference file from UCSC (http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cytoBand.txt.gz).

Annotation and Possible Filtering
---------------------------------

1. For ``liftover_hg19.py``, three lines are added to the header:

::

  ##INFO=<ID=hg19_chr,Number=.,Type=String,Description="CHROM in hg19 using LiftOver from pyliftover">
  ##INFO=<ID=hg19_pos,Number=.,Type=Integer,Description="POS in hg19 using LiftOver from pyliftover (converted back to 1-based)">
  ##INFO=<ID=hg19_end,Number=1,Type=Integer,Description="END in hg19 using LiftOver from pyliftover (converted back to 1-based)">

The data associated with these tags are also added to the INFO field of the ``vcf`` for qualifying variants using the following criteria.

* For the **hg19** LiftOver, all variants with successful conversions at both breakpoints will include data for the ``hg19_chr`` and both the ``hg19_pos`` (breakpoint 1) and ``hg19_end`` (breakpoint 2) tags in the INFO field. A failed conversion (e.g., coordinates that do not have a corresponding location in **hg19**) will not print the tags or any LiftOver data, but each breakpoint is treated separately, such that a variant can contain data for ``hg19_chr`` and ``hg19_pos``, but no ``hg19_end``, or ``hg19_chr`` and ``hg19_end``, but no ``hg19_pos``. If both breakpoints lift over successfully, ``hg19_chr`` is only present once with both ``hg19_pos`` and ``hg19_end``.
* Given that pyliftover does not convert ranges, the single-point coordinate in **hg38** corresponding to each variant's CHROM and POS (or END) are used as query, and the **hg19** coordinate (result) will also be a single-point coordinate.

2. For ``SV_worst_and_locations.py``, three new fields are added to the ``CSQ`` INFO field initially created by ``VEP``. These are:

* ``Most_severe``, which will have a value of ``1`` if the transcript is the most severe, and will otherwise be blank.
* ``Variant_5_prime_location``, which gives the location for breakpoint 1 relative to the transcript (options below)
* ``Variant_3_prime_location``, which gives the location for breakpoint 2 relative to the transcript (options below)

Options for the location fields include:
``Indeterminate``, ``Upstream``, ``Downstream``, ``Intronic``, ``Exonic``, ``5_UTR``, ``3_UTR``, ``Upstream_or_5_UTR``, ``3_UTR_or_Downstream``, or ``Within_miRNA``.

Additionally, for each variant this step removes annotated transcripts that do not possess one of the following biotypes: ``protein_coding``, ``miRNA``, or ``polymorphic_pseudogene``.  Following this filtration, if a variant no longer has any annotated transcripts, that variant is also filtered out of the ``vcf`` file.

3. For ``SV_cytoband.py``, the following two lines are added to the header:

::

  ##INFO=<ID=Cyto1,Number=1,Type=String,Description="Cytoband for SV start (POS) from hg38 cytoBand.txt.gz from UCSC">
  ##INFO=<ID=Cyto2,Number=1,Type=String,Description="Cytoband for SV end (INFO END) from hg38 cytoBand.txt.gz from UCSC">

Each variant will receive a ``Cyto1`` annotation which corresponds to the cytoband position of breakpoint 1 (which is ``POS`` in the ``vcf``), and a ``Cyto2`` annotation which corresponds to the cytoband position of breakpoint 2 (which is ``END`` in the ``INFO`` field).

Output
------

The output is an annotated CNV ``vcf`` file.  No variants are removed, but secondary annotations are added to qualifying variants as described above.


Length Filtering
++++++++++++++++

Note: We are not currently conducting length filtering of ``BIC-seq2`` CNVs. The step is included in the pipeline for historic reasons, but is functionally turned off by providing a maximum length that is larger than chr1 (250000000 bp). This is the same max size used in ``VEP`` for annotations.

This step uses ``SV_length_filter.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to remove the longest CNVs from the sample CNV ``vcf`` file. The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_SV_length_filter_plus_vcf-integrity-check.cwl

Requirements
------------

A single, annotated CNV ``vcf`` file is expected as input alongside a maximum length (currently 250,000,000 bp).

Filtering
---------

Currently none.

Output
------

The resulting ``vcf`` file is checked for integrity.  This is the **full-annotated vcf** that is ingested into the CGAP Portal.


VCF Annotation Cleaning
+++++++++++++++++++++++

This step uses ``SV_annotation_VCF_cleaner.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to remove ``VEP`` annotations from the **full-annotated vcf** to create the **HiGlass vcf**.  These annotations are removed to improve loading speed in the ``HiGlass`` genome browser. The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_SV_annotation_VCF_cleaner_plus_vcf-integrity-check.cwl

Requirements
------------

The final **full-annotated vcf**.

Cleaning
--------

To improve loading speed in the ``HiGlass`` genome browser, ``VEP`` annotations are removed from the **full-annotated vcf** and the ``REF`` and ``ALT`` fields are simplified using the ``SV_annotation_VCF_cleaner.py`` script.

Output
------

The output is a modified version of the **full-annotated vcf** that has been cleaned for the ``HiGlass`` genome browser.  This is ingested into the CGAP Portal as the **Higlass vcf** and is only used for visualization. The resulting ``vcf`` file is checked for integrity.
