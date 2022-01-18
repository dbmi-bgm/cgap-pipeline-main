=======================
hg19 LiftOver and HGVSG
=======================

This step uses ``liftover_hg19.py`` (https://github.com/dbmi-bgm/cgap-scripts) and ``hgvsg_creator.py`` to add hg19 coordinates and hgvsg entries to qualifying variants from a filtered input ``vcf`` file. The output ``vcf`` file is checked for integrity.

* CWL: workflow_hg19lo_hgvsg_plus_vcf-integrity-check.cwl


Requirements
++++++++++++

Must be run on input ``vcf`` following ``bcftools norm`` since it only allows one variant per line in the input ``vcf``.


Output
++++++

This step creates an output ``vcf`` file that has the same entries from the input ``vcf`` file (no line is removed), but with additional information. Five lines are added to the header:

::

  ##INFO=<ID=hgvsg,Number=.,Type=String,Description="hgvsg created from variant following best practices - http://varnomen.hgvs.org/recommendations/DNA/">
  ##INFO=<ID=hg19_chr,Number=.,Type=String,Description="CHROM in hg19 using LiftOver from pyliftover">
  ##INFO=<ID=hg19_pos,Number=.,Type=Integer,Description="POS in hg19 using LiftOver from pyliftover (converted back to 1-based)">
  ##INFO=<ID=hg19_end,Number=1,Type=Integer,Description="END in hg19 using LiftOver from pyliftover (converted back to 1-based)">
  ##INFO=<ID=hgvsg_hg19,Number=1,Type=String,Description="hgvsg for liftover coordinates in hg19 created from variant following best practices - http://varnomen.hgvs.org/recommendations/DNA/">

The data associated with these tags are also added to the INFO field of the ``vcf`` for qualifying variants using the following criteria. Note that although hg19_end is written into the header of all ``vcf`` files, this tag should only appear in the INFO field of structural variants (SVs) and CNVs (CNVs) given the requirement for an END coordinate in the INFO block (which is not present in SNVs).

For hg19 LiftOver:

1. For the hg19 LiftOver, all variants with successful conversions will include data for both the ``hg19_chr=`` and ``hg19_pos=`` tags in the INFO field. Failed conversions (e.g., coordinates that do not have a corresponding region in hg19) will not print the tags or any LiftOver data.
2. Given that pyliftover does not convert ranges, the single-point coordinate in hg38 corresponding to each variant's CHROM and POS are used as query, and the hg19 coordinate (result) will also be a single-point coordinate.

For hgvsg:

1. For hgvsg, best practices (http://varnomen.hgvs.org/recommendations/DNA/) are followed. All variants on the 23 nuclear chromosomes receive a ``g.`` and all mitochondrial variants receive an ``m.``.
2. All variants should receive an ``hgvsg=`` tag within their INFO field with data pertaining to their chromosomal location and variant type.
3. If a variant on a contig (e.g., chr21_GL383580v2_alt) were to be included in the filtered ``vcf``, it would not receive an ``hgvsg=`` tag, or any hgvsg data, since contigs were not included in the python script's library of chromosomal conversions (e.g., chr1 is NC_000001.11).
3. Any variant that receives a value for both ``hg19_pos`` and ``hg19_chr`` will also receive an entry for the ``hgvsg_hg19=`` tag based on this liftover position. These are calculated identically to the ``hg38`` hgvsg fields, but with the appropriate ``hg19`` chromosomal accessions.

For more details, see https://cgap-annotations.readthedocs.io/en/latest/variants_sources.html#hg19-liftover and https://cgap-annotations.readthedocs.io/en/latest/variants_sources.html#hgvsg
