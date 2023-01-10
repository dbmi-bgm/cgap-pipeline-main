===============
Main Repository
===============

This is the main GitHub repository for the CGAP bioinformatics pipelines (https://github.com/dbmi-bgm/cgap-pipeline-main).
The repository bundles the latest stable version for each of the currently available modules.

The repository also contains:

- *MetaWorkflow* objects to describe pipelines that use components from multiple modules
- Basic Docker images that are used as template for most of the module specific images

Finally, there is a README that documents how to install and set up the repository to deploy the pipeline components.


Docker images
#############

The image ``ubuntu-py-generic`` is based on Ubuntu 20.04 and contains (but is not limited to) the following software packages:

- python (3.8.12)
- OpenJDK (8.0.312)
- Miniconda3
