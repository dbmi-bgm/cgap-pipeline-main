=====================
Style Guide CGAP Docs
=====================

This is internal documentation for adding new pages or editing pages within the CGAP Pipeline main documentation and other repositories linked to CGAP Pipeline.

===============================
Section 1 - Page layout example
===============================
**Note that other characters can be used for sections and subsections e.g., (##...))**

==========
Page Title
==========

Optional text.

Section Title
+++++++++++++

Sample text.

Subsection Title
----------------

Sample text.


===========================
Section 2 - Text formatting
===========================

1. When a command, parameter, or file format is mentioned, place it in double backquotes \`\`command\`\` which will appear like this ``command``
2. Links should be provided to the repo for all scripts that exist outside of the Docker folder for the repo in question. E.g., ``hg19_liftover.py`` (https://github.com/dbmi-bgm/cgap-scripts)
3. Long links and external (non-CGAP) links can be hidden. E.g., `Fisher's exact test <https://en.wikipedia.org/wiki/Fisher%27s_exact_test#>`_
4. For pipeline steps, after a short description, the CWL line should be placed above all subsequent sections (i.e., Input, Requirements, etc.)
5. Section titles always begin with a capital letter (unless you are matching style for a program name, e.g., ``HaplotypeCaller``). All subsequent words in the section title should also be capitalized, except: a, an, the, at, by, for, in, of, on, to, up, and, as, but, or, and nor. If any of these words start a title, they should be capitalized
6. Links between docs pages (e.g., for pipelines that use steps from multiple repos like CGAP Sentieon Joint Calling Pipeline) should be done using ``:doc:`` followed immediately by the custom name for the link and the link out. See the CGAP Sentieon Joint Calling Pipeline pages for examples
7. Genome builds should be formatted with bold. For example, **hg19/GRCh37** and **hg38/GRCh38**

====================================================================
Section 3 - Pipeline folder organization and file naming conventions
====================================================================

Pipelines currently fall into the following top-level directories:
``Base``, ``Downstream``, ``Upstream``, and ``Other``, alongside the link-outs provided in ``Support Repos``.

For all of these top level folders, only one ``rst`` file is present that serves as a brief overview and a table of contents for all the subfolders, which each contain individual pipelines. The pipeline subfolders (named after the pipeline) should contain the following:
  1. ``index-<folder_name>.rst``, a table of contents for the following ``rst`` files for the pipeline
  2. ``news-<folder_name>.rst``, a news page for pipeline updates
  3. ``overview-<folder_name>.rst``, the main overview page with links to pipeline steps, descriptions, etc..
  4. ``qc-<folder_name>.rst``, the optional QC page for the pipeline
  5. ``validation-<folder_name>.rst``, the optional validation page for the pipeline
  6. ``Pages``, a folder which contains all pages linked to in the ``overview`` and ``qc`` pages. Steps contain ``-step-`` in the filename and QC pages contain ``-qc-`` in the filename

Note, for all ``rst`` file names, the ``<folder_name>`` (which is the short form of the pipline e.g., ``CNV_germline``) contains underscores, and the remaining portions of the filename contains hyphens (e.g, ``SNV_germline-step-filtering.rst``). See below for an example of directory structure and file naming.

::

    Pipelines
    ├── Base
    └── Downstream
        ├── CNV_germline
        ├── SNV_germline
        ├── SV_germline
        │   ├── Pages
        │   │   ├── SV_germline-qc-qcvcf.rst
        │   │   ├── SV_germline-step-part-1.rst
        │   │   └── ...
        │   ├── index-SV_germline.rst
        │   ├── news-SV_germline.rst
        │   ├── overview-SV_germline.rst
        │   └── qc-SV_germline.rst
        └── Downstream_pipelines.rst

================
Section 4 - News
================

Currently, each pipeline has its own ``news-<pipeline>.rst`` file, which must be manually updated with new releases. There is also a ``news-main.rst`` file that should contain information on major releases (e.g., v0.0.27, v1.0.0).

It has not been decided how minor updates will be recorded in the pipeline-specific news files at this point, but a decision should be made and it should remain consistent between pipelines.
