===========
LiftoverVcf
===========

Base implementation of GATK ``LiftoverVcf`` to convert coordinates for variants provided in ``vcf`` format to a different genome build.

* CWL: gatk_liftover.cwl


hg19/GRCh37 to hg38/GRCh38
++++++++++++++++++++++++++

We have a custom implementation for the pipeline with an additional pre-processing step to convert coordinates from **hg19/GRCh37** to **hg38/GRCh38**.
The pre-processing uses ``preprocess_liftover.py`` script to:

  - Check if sample identifiers in the ``vcf`` file match a list of expected identifiers
  - Exclude non-standard chromosomes and contigs (e.g., GL000225.1)
  - Format chromosome names by adding ``chr`` prefix if missing (i.e., **hg19** uses only numbers for the main chromosomes). This is necessary as the chain file coordinates use ``chr`` based names for chromosomes.

The lift-over step uses the ``hg19ToHg38.over.chain.gz`` chain file (https://cgap-annotations.readthedocs.io/en/latest/liftover_chain_files.html#hg19-grch37-to-hg38-grch38) to map the coordinates between the two builds.

* CWL: workflow_gatk_liftover.cwl


----

`GATK LiftoverVcf <https://gatk.broadinstitute.org/hc/en-us/articles/5358875253147-LiftoverVcf-Picard->`__.
