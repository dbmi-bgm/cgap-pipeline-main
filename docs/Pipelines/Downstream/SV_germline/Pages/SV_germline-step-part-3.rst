==============================================================
Part 3. Structural Variant Filtering and Secondary Annotations
==============================================================


Initial Annotation Filtering
++++++++++++++++++++++++++++

The multi-step workflow carries out ``granite`` filtering, coding filtering, gnomAD SV allele frequency filtering and SV type selection.

* CWL: workflow_granite-filtering_SV_selector_plus_vcf-integrity-check.cwl

Requirements
------------

A single, annotated SV ``vcf`` file is required as input. The annotations should include annotation of transcripts through ``VEP`` and gnomAD SV allele frequency through ``sansa``.

The filtering step is composed of multiple steps and the output ``vcf`` file is checked for integrity to ensure the format is correct and the file is not truncated.

Genelist
---------

The genelist step uses ``granite geneList`` to clean VEP annotations for transcripts that are not mapping to any gene of interest (not present on the CGAP Portal). This step does not remove any variants, but only modifies the VEP annotation.

Inclusion List
--------------

The Inclusion list steps use ``granite`` command to filter-in exonic and functionally relevant variant based on VEP annotations. This step removes a large number of SVs from the initial call set.

Exclusion List
--------------

The Exclusion list step uses ``granite`` command to filter-out common variants based on gnomAD SV population allele frequency (AF > 0.01). Variants without gnomAD SV annotations are retained.

SV Type Selection
-----------------

This step uses ``SV_type_selector.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to filter out unwanted SV types. Currently only DEL and DUP are retained.

Output
------

The output is a filtered ``vcf`` file containing fewer entries compared to the input ``vcf``. The content of the remaining entries are identical to the input (no additional information added or removed). The resulting ``vcf`` file is checked for integrity.


20 Unrelated Filtering
++++++++++++++++++++++

This step uses ``20_unrelated_SV_filter.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to assess common and artefactual SVs in 20 unrelated samples and allows to filter them out. The 20 unrelated reference files (SV ``vcf`` files) were each generated using ``Manta`` for a single diploid individual (see: https://cgap-annotations.readthedocs.io/en/latest/unrelated_references.html).

* CWL: workflow_20_unrelated_SV_filter_plus_vcf-integrity-check.cwl

Requirements
------------

A single, annotated SV ``vcf`` file is expected as input alongside a ``tar`` folder of 20 unrelated SV ``vcf`` files. This step cannot currently assess SVs other than DELs and DUPs (which are provided to the SVTYPE argument), although the ``vcf`` files can contain these variants.

Matching and Filtering
----------------------

When comparing variants from the sample SV ``vcf`` file to an unrelated SV ``vcf`` file, the following matching criteria are currently in place:

  1. SVTYPE must match
  2. Breakpoints at 5' end must be +/- 50 bp from each other
  3. Breakpoints at 3' end must be +/- 50 bp from each other
  4. SVs must reciprocally overlap by a minimum of 80%

The matching step is carried out as follows:

  1. The sample SV ``vcf`` file is compared pair-wise to each of 20 unrelated SV ``vcf`` reference files and SVs that match between are written out from the sample SV ``vcf`` file.
  2. This results in 20 "matched" SV ``vcf`` files, where each file contains the subset of SVs from the sample file that overlapped a single individual from the 20 unrelated references.
  3. The "matched" SV ``vcf`` files are read into a dictionary that counts the number of times each sample SV is found (max of 1 time per 20 files = 20 matches).

The filtering step reads through the sample SV ``vcf`` file a final time and writes a filtered SV ``vcf`` file that only contains SVs that matched a maximum of n individuals. The default is currently n = 1, such that sample SVs that match 2 or more of the 20 unrelated individuals are filtered out.

Output
------

The output is a filtered ``vcf`` file containing fewer entries compared to the input ``vcf``.  The variants that remain after filtering will receive an additional annotation, ``UNRELATED=n``, where n is the number of matches found within the 20 unrelated SV ``vcf`` files.


Secondary Annotation
++++++++++++++++++++

This workflow contains a series of short steps that add additional annotations to the existing ``vcf`` file, before the output ``vcf`` file is checked for integrity. This workflow makes use of ``liftover_hg19.py`` (https://github.com/dbmi-bgm/cgap-scripts) alongside ``SV_worst_and_locations.py`` and ``SV_cytoband.py`` (both from https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to create annotations pertaining to the breakpoint locations in **hg19**, the breakpoint locations relative to the transcript they impact (e.g., Exonic, Intronic, etc.), the most severe consequence from ``VEP`` annotation, and the cytoband(s) the breakpoints overlap with. The resulting ``vcf`` file might include slighlty fewer variants given a filtration step conducted in ``SV_worst_and_locations.py``.

* CWL: workflow_SV_secondary_annotation_plus_vcf-integrity-check.cwl

Requirements
------------

This annotation step is present in Part 3 because the three python scripts used are designed to work only on DELs and DUPs (no INV, BND, INS) and because there is a possibility of filtering out a small number of variants during ``SV_worst_and_locations.py``. Both the cytoband annotation step and the liftover step also require the END field in the INFO block. This workflow requires a single SV ``vcf`` file that has undergone **Initial Annotation Filtering Step** (which selects for DELs and DUPs), the **hg38** to **hg19** chain file for liftover (http://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz), and the **hg38** cytoband reference file from UCSC (http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cytoBand.txt.gz).

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

The output is an annotated SV ``vcf`` file where secondary annotations are added to qualifying variants as described above. Some variants may be lost as described.


Length Filtering
++++++++++++++++

This step uses ``SV_length_filter.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to remove the longest SVs from the sample SV ``vcf`` file. The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_SV_length_filter_plus_vcf-integrity-check.cwl

Requirements
------------

A single, annotated SV ``vcf`` file is expected as input alongside a maximum length (currently 10,000,000 bp).

Filtering
---------

Based on the maximum length provided, this step filters the longest SVs from the sample SV ``vcf`` file.  This is currently done to remove nearly chromosome-sized SVs that we believe to be artefactual, which result in very long gene lists during ingestion to the CGAP Portal.

Output
------

The output is a filtered ``vcf`` file containing slightly fewer entries.  No additional information is added or removed for remaining variants. The resulting ``vcf`` file is checked for integrity.  This is the **Full Annotated VCF** that is ingested into the CGAP Portal.


VCF Annotation Cleaning
+++++++++++++++++++++++

This step uses ``SV_annotation_VCF_cleaner.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to remove ``VEP`` annotations from the **Full Annotated VCF** to create the **HiGlass SV VCF**.  These annotations are removed to improve loading speed in the ``HiGlass`` genome browser. The resulting ``vcf`` file is checked for integrity.

* CWL: workflow_SV_annotation_VCF_cleaner_plus_vcf-integrity-check.cwl

Requirements
------------

The final **Full Annotated VCF**.

Cleaning
--------

To improve loading speed in the ``HiGlass`` genome browser, ``VEP`` annotations are removed from the **Full Annotated VCF** and the ``REF`` and ``ALT`` fields are simplified using the ``SV_annotation_VCF_cleaner.py`` script.

Output
------

The output is a modified version of the **Full Annotated VCF** that has been cleaned for the ``HiGlass`` genome browser.  This is ingested into the CGAP Portal as the **Higlass SV VCF** and is only used for visualization. The resulting ``vcf`` file is checked for integrity.
