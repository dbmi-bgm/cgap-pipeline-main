===========
LiftoverVcf
===========

This step runs ``gatk LiftoverVcf`` (``picard``) command to convert coordinates for variants provided in ``vcf`` format to a different genome build.

* CWL: gatk_liftover.cwl

hg19/GRCh37 to hg38
+++++++++++++++++++

We have a custom implementation of this step with an additional pre-processing step to convert coordinates from **hg19/GRCh37** to **hg38**.
This extra step uses ``preprocess_liftover.py`` (https://github.com/dbmi-bgm/cgap-pipeline-base) script to:

  - Check if sample identifiers in ``vcf`` file match a list of expected identifiers
  - Exclude non-standard chromosomes and contigs (i.e, GL000225.1)
  - Format chromosome names by adding ``chr`` prefix if missing (i.e., **hg19** only uses numbers for the main chromosomes)

* CWL: workflow_gatk_liftover.cwl
