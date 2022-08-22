===========
LiftoverVcf
===========

This step runs ``gatk LiftoverVcf`` command to convert coordinates for variants provided in ``vcf`` format to a different genome build.

* CWL: gatk_liftover.cwl

hg19/GRCh37 to hg38
+++++++++++++++++++

We have a custom implementation of this step with an additional pre-processing to convert coordinates from **hg19/GRCh37** to **hg38**.
The pre-processing uses ``preprocess_liftover.py`` (https://github.com/dbmi-bgm/cgap-pipeline-base) script to:

  - Check if sample identifiers in ``vcf`` file match a list of expected identifiers
  - Exclude non-standard chromosomes and contigs (i.e., GL000225.1)
  - Format chromosome names by adding ``chr-`` prefix if missing (i.e., **hg19** uses only numbers for the main chromosomes). This is necessary as the chain file coordinates use ``chr-`` based names for chromosomes. 

The step uses the ``hg19ToHg38.over.chain.gz`` chain file (https://cgap-annotations.readthedocs.io/en/latest/liftover_hg19_hg38.html) to translate the coordinates between the two builds.

* CWL: workflow_gatk_liftover.cwl
