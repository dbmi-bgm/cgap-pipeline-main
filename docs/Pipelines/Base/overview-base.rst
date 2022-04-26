======================
Overview - Base Module
======================

The CGAP Pipeline Base Module (https://github.com/dbmi-bgm/cgap-pipeline-base) contains the CWL files, workflows, metaworkflows, Dockerfiles and CGAP Portal objects necessary to run ``md5``, ``FastQC``, and format conversion from ``cram`` to ``fastq``. This module is necessary for general CGAP Portal functionality and should always be included when deploying a new CGAP account.


Docker Images
#############

The Dockerfiles provided in this GitHub repository can be used to build public docker images, or if built through ``cgap-pipeline-utils`` ``deploy_pipeline.py`` (https://github.com/dbmi-bgm/cgap-pipeline-utils), private ECR images will be created for the provided AWS account.

The ``md5`` image contains (but is not limited to) the following software packages:

- md5sum (8.25)

The ``fastqc`` image contains (but is not limited to) the following software packages:

- fastqc (0.11.9)

The ``base`` image contains (but is not limited to) the following software packages:

- samtools (1.9)
- cramtools (0b5c9ec)
- pigz (2.6)
- pbgzip (2b09f97)

Pipeline Parts and Runtimes
###########################

Below are the current runtimes for components of the CGAP Pipeline - Base Module.

.. image:: ../../images/base.png
  :width: 500

Pipeline Steps
##############

.. toctree::
   :maxdepth: 1

   Pages/md5
   Pages/fastqc
   Pages/cram2fastq
