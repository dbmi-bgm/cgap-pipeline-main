======================
Overview - SNV Somatic
======================

CGAP Pipeline SNV Somatic (https://github.com/dbmi-bgm/cgap-pipeline-SNV-somatic) is our pipeline for parsing the output ``vcf`` file from the `CGAP Somatic Sentieon Pipeline <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Downstream/somatic_sentieon/index-somatic_sentieon.html>`_. The input ``vcf`` contains Single Nucleotide Variants (SNVs), short INsertions and DELetions (INDELs), and Structural Variants (SVs), which must be filtered, split and reformatted for use in the somatic browser.

Docker Image
############

The Dockerfile provided in this GitHub repository can be used to build a public docker image, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils) a private ECR image will be created for the AWS account provided.

The image contains (but is not limited to) the following software packages:

- vcftools (954e607)
- granite (0.2.0)

Pipeline Steps
##############

.. toctree::
   :maxdepth: 4

   Pages/SNV_somatic-step-part-1
