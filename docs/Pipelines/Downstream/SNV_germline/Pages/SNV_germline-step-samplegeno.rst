==============
Add SAMPLEGENO
==============

This step is for portal compatibility, and can be skipped for non-portal use cases. The tag SAMPLEGENO is added to the INFO field during this step.

* CWL: samplegeno.cwl

::

    ##INFO=<ID=SAMPLEGENO,Number=.,Type=String,Description="Sample genotype information. Subembedded:'samplegeno':Format:'NUMGT|GT|AD|SAMPLEID'">

The tag is used to keep the information about the original genotypes and ADs before splitting multi-allelic variants.
It also offers a unique place for accessing the genotype and AD information for all the samples.

This step is run prior to the multi-allelic splitting carried out in the VEP workflow.
