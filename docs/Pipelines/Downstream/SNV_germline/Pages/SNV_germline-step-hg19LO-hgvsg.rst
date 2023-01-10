===============================
hg19/GRCh37 lift-over and HGVSg
===============================

This step uses ``liftover_hg19.py`` (https://github.com/dbmi-bgm/cgap-scripts) and ``hgvsg_creator.py`` to add **hg19/GRCh37** coordinates and HGVSg entries to qualifying variants from a filtered input ``vcf`` file.
The output ``vcf`` file is checked for integrity.

* CWL: workflow_hg19lo_hgvsg_plus_vcf-integrity-check.cwl


Requirements
++++++++++++

Must be run on input ``vcf`` following BCFtools ``norm`` since it only allows one variant per line in the input ``vcf`` file.


Output
++++++

This step creates an output ``vcf`` file that has the same entries from the input ``vcf`` file (no line is removed), but with additional information.
Five definitions are added to the header:

::

  ##INFO=<ID=hgvsg,Number=.,Type=String,Description="hgvsg created from variant following best practices - http://varnomen.hgvs.org/recommendations/DNA/">
  ##INFO=<ID=hg19_chr,Number=.,Type=String,Description="CHROM in hg19 using LiftOver from pyliftover">
  ##INFO=<ID=hg19_pos,Number=.,Type=Integer,Description="POS in hg19 using LiftOver from pyliftover (converted back to 1-based)">
  ##INFO=<ID=hg19_end,Number=1,Type=Integer,Description="END in hg19 using LiftOver from pyliftover (converted back to 1-based)">
  ##INFO=<ID=hgvsg_hg19,Number=1,Type=String,Description="hgvsg for liftover coordinates in hg19 created from variant following best practices - http://varnomen.hgvs.org/recommendations/DNA/">

The data associated with these tags are also added to the INFO field of the ``vcf`` for qualifying variants using the following criteria.

For **hg19/GRCh37** lift-over:

  1. For the **hg19/GRCh37** lift-over, all variants with successful conversions will include data for both the ``hg19_chr=`` and ``hg19_pos=`` tags in the INFO field. Failed conversions (e.g., coordinates that do not have a corresponding region in **hg19/GRCh37**) will not print the tags or any lift-over data
  2. Given that pyliftover does not convert ranges, the single-point coordinate in **hg38/GRCh38** corresponding to each variant's CHROM and POS are used as query, and the **hg19/GRCh37** coordinate (result) will also be a single-point coordinate

For HGVSg:

  1. For HGVSg, best practices (http://varnomen.hgvs.org/recommendations/DNA/) are followed. All variants on the 23 nuclear chromosomes receive a ``g.`` and all mitochondrial variants receive an ``m.``
  2. All variants should receive an ``hgvsg=`` tag within their INFO field with data pertaining to their chromosomal location and variant type
  3. If a variant on a contig (e.g., chr21_GL383580v2_alt) were to be included in the filtered ``vcf``, it would not receive an ``hgvsg=`` tag, or any HGVSg data, since contigs were not included in the python script's library of chromosomal conversions (e.g., chr1 is NC_000001.11)
  4. Any variant that receives a value for both ``hg19_pos`` and ``hg19_chr`` will also receive an entry for the ``hgvsg_hg19=`` tag based on this lift-over position. These are calculated identically to the **hg38/GRCh38** HGVSg fields, but with the appropriate **hg19/GRCh37** chromosomal accessions

**Note**: Although ``hg19_end`` is written into the header of all ``vcf`` files, this tag should only appear in the INFO field of structural and copy number variants given the requirement for an ``END`` coordinate in the INFO block (which is not present in SNVs).

For more details, see https://cgap-annotations.readthedocs.io/en/latest/liftover_chain_files.html#hg38-grch38-to-hg19-grch37 and https://cgap-annotations.readthedocs.io/en/latest/variants_sources.html#hgvsg.
