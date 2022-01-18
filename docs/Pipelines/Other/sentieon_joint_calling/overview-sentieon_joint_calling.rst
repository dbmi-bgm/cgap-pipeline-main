=================================
Overview - Sentieon Joint Calling
=================================

The CGAP Pipeline for Joint Calling with Sentieon (currently contained within https://github.com/dbmi-bgm/cgap-pipeline-upstream-sentieon) accepts individual ``g.vcf`` files generated from Whole Exome Sequencing (WES) or Whole Genome Sequencing (WGS) samples through either of the `CGAP Upstream Pipelines <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Upstream/Upstream_pipelines.html>`_, followed by the appropriate `HaplotypeCaller <https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Downstream/SNV_germline/Pages/SNV_germline-step-haplotypecaller.html>`_ step (WES or WGS) from the SNV Germline Downstream Pipeline.

In this pipeline, Sentieon's `GVCFtyper <https://support.sentieon.com/manual/usages/general/#gvcftyper-algorithm>`_ is used to combine ``g.vcf`` files from multiple samples and genotype the resulting variants. This pipeline produces a jointly called ``vcf`` file as output.


Docker Image
############

The Dockerfile provided in this GitHub repository can be used to build a public docker image, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils) a private ECR image will be created for the provided AWS account.

The image contains (but is not limited to) the following software packages:

- sentieon (202010.02)


Pipeline Parts and Runtimes
###########################

The CGAP Sentieon Joint Calling Pipeline is primarily used for variant calling following GATK (Genome Analysis Toolkit) Best Practice using the Sentieon ``GVCFtyper`` algorithm.

This single-step pipeline runs for under an hour with WES data from around 75 individuals.


Pipeline Steps
##############

.. toctree::
   :maxdepth: 1

   Pages/sentieon_joint_calling-step-GVCFtyper
   Pages/sentieon_joint_calling-step-annotation-Fisher
