=====================
Style Guide CGAP Docs
=====================

This is internal documentation for adding new pages or editing pages within the CGAP Pipeline Master documentation and other repositories linked to CGAP Pipeline (e.g., Support Repos).

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

1. When a program or file format is mentioned, place it in double backquotes \`\`Program\`\` which will appear like this ``Program``.

2. When mentioning the pipeline by name, use capital letters, e.g., CGAP Pipeline SNV Germline or CGAP SNV Germline Pipeline. When referring to "a pipeline", "this pipeline",   "this pipeline", etc. feel free to use lowercase. Try to stick to either the short version (e.g., this pipeline) or the full version ("the CGAP SNV Germline Pipeline") instead of something in between (e.g., do not say the SV pipeline). As we expand our offerings, there will likely be multiple SV pipelines, and this will introduce confusion for the person reading the docs and also likely result in inconsistency with capitalization.

3. Links should be provided to the repo for all scripts, especially those that exist outside of the Docker folder for the repo in question. E.g., ``hg19_liftover.py`` (https://github.com/dbmi-bgm/cgap-scripts) in both the CGAP SV and SNV Germline Piplines.

4. Long links and external (non-CGAP) links can be hidden. E.g., `Fisher's exact test <https://en.wikipedia.org/wiki/Fisher%27s_exact_test#>`_). Try not to hide CGAP links to increase visibility for our repositories and scripts in the documentation.

5. For pipeline steps, after a short description, the CWL line should be placed above all subsequent sections (i.e., Input, Requirements, etc.)

6. Section titles always begin with a capital letter. All subsequent words in the section title should also be capitalized, except: a, an, the, at, by, for, in, of, on, to, up, and, as, but, or, and nor. If any of these words start a title, they should be capitalized.

7. Links between docs pages (e.g., for pipelines that use steps from multiple repos like CGAP Sentieon Joint Calling Pipeline) should be done using ``:doc:`` followed immediately by the custom name for the link and the link out, e.g., ```VEP step </Pipelines/Downstream/SNV_germline/Pages/SNV_germline-step-vep>`.`` See the CGAP Sentieon Joint Calling Pipeline pages for examples.

====================================================================
Section 3 - Pipeline folder organization and file naming conventions
====================================================================

Pipelines currently fall into the following top-level directories:
``Base``, ``Downstream``, ``Upstream``, and ``Other``, alongside the link-outs provided in ``Support Repos``.

For all of these top level folders, only one ``rst`` file is present that serves as a brief overview and a table of contents for all the subfolders, which each contain individual pipelines. The pipeline subfolders (named after the pipeline) should contain the following:
  1. ``index-<folder_name>.rst``, a table of contents for the following ``rst`` files for the pipeline
  2. ``news-<folder_name>.rst``, a news page for pipeline updates
  3. ``overview-<folder_name>.rst``, the main overview page with links to pipeline steps, descriptions, etc.
  4. ``qc-<folder_name>.rst``, the optional QC page for the pipeline
  5. ``validation-<folder_name>.rst``, the optional validation page for the pipeline
  6. ``Pages``, a folder which contains all pages linked to in the ``overview`` and ``qc`` pages. Steps contain ``-step-`` in the filename and QC pages contain ``-qc-`` in the filename.

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
