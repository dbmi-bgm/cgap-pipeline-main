======================
Overview - SNV Somatic
======================

The CGAP Pipelines module for somatic Single Nucleotide Variants (SNVs) (https://github.com/dbmi-bgm/cgap-pipeline-SNV-somatic) is our solution to filter and annotate the variants called by `CGAP Somatic Sentieon module <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Downstream/somatic_sentieon/index-somatic_sentieon.html>`_.
The input ``vcf`` contains SNVs, short Insertions and Deletions (INDELs), and Structural Variants (SVs), which are filtered, annotated and reformatted for use in the somatic browser.

Docker Image
############

The Dockerfiles provided in this GitHub repository can be used to build public docker images.
If built through ``portal-pipeline-utils`` ``pipeline_deploy`` command (https://github.com/dbmi-bgm/portal-pipeline-utils), private ECR images will be created for the target AWS account.

The image contains (but is not limited to) the following software packages:

- vcftools (954e607)
- granite (0.2.0)

Pipeline Steps
##############

.. toctree::
   :maxdepth: 4

   Pages/SNV_somatic-step-part-1


References
##########

`Sentieon <https://www.sentieon.com>`__.
