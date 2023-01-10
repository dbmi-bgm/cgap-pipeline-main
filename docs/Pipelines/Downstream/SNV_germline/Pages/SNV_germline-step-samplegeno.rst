==================
Add ``SAMPLEGENO``
==================

This step is for portal compatibility, and can be skipped for non-portal use cases.
The tag ``SAMPLEGENO`` is added by ``samplegeno.py`` script (https://github.com/dbmi-bgm/cgap-scripts) to the INFO field of the ``vcf`` file.

* CWL: samplegeno.cwl

::

    ##INFO=<ID=SAMPLEGENO,Number=.,Type=String,Description="Sample genotype information. Subembedded:'samplegeno':Format:'NUMGT|GT|AD|SAMPLEID'">

The tag is used to store the original information about genotypes and allelic depth (``AD``) before splitting multi-allelic to bi-allelic variants.
It also offers a unique place for accessing the genotype and ``AD`` information of all the samples.
