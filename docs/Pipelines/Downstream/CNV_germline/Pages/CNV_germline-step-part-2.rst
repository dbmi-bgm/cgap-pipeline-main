======================================
Part 2. Copy Number Variant Annotation
======================================

sansa and VEP
+++++++++++++

This step uses ``sansa`` and ``VEP`` to annotate the CNVs identified and combines the outputs into a single ``vcf`` file. The resulting ``vcf`` file is checked for integrity. It should be noted that the gnomAD SV database, which we annotate against, only contains calls obtained from SV algorithms. This is currently the best available dataset for SVs, but does not contain calls generated from CNV algorithms.

* CWL: workflow_sansa_vep_combined_annotation_plus_vcf-integrity-check.cwl

sansa
-----

First, ``sansa`` is run using ``sansa.sh`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to identify CNVs that match the GRCh38 liftover of the gnomAD v2 structural variant database (https://gnomad.broadinstitute.org/downloads#v2-liftover-structural-variants). SVs in this database have allele frequencies from several human populations. ``sansa.sh`` sorts the input ``vcf`` file and then runs the following command for ``sansa``:

``sansa annotate -m -n -b 50 -r 0.8 -s all -d $gnomAD $vcf``

  - ``-m`` returns all SVs (including those without matches to the database)
  - ``-n`` allows for matches between different SV types (to allow CNV to match DEL and DUP)
  - ``-b 50`` is the default parameter for maximum breakpoint offset (in bp) between the newly-identified SV and the SV in gnomAD SV
  - ``-r 0.8`` is nearly the default parameter (default is 0.800000012) for minimum reciprocal overlap between SVs
  - ``-s all`` provides all matches instead of automatically selecting the single best match
  - ``-d $gnomAD`` is the gnomAD SV database
  - ``$vcf`` is the input ``vcf`` file

Some additional bash commands convert the ``sansa`` output into ``txt`` format for use in the combine step (below).

VEP
---

Next, ``VEP`` is run using ``vep-annot_SV.sh`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline) to annotate the CNVs with genes and transcripts. A maximum CNV size slightly larger than chr1 in the **hg38** genome ``--max_sv_size 250000000`` is used in the ``VEP`` command in order to avoid unwanted filtering of large CNVs at this step. The ``--overlaps`` option is also included to provide the bp overlap between the ``VEP`` feature and the CNV (reported in bp and percentage). The ``--canonical`` option is included so that canonical transcripts are flagged. ``VEP`` outputs an annotated ``vcf`` containing all variants.

Combine sansa and VEP
---------------------

Finally, the outputs from ``sansa`` and ``VEP`` are combined using ``combine_sansa_and_VEP_vcf.py`` (https://github.com/dbmi-bgm/cgap-pipeline-SV-germline). The ``VEP`` ``vcf`` file is used as a scaffold, and gnomAD SV annotations from ``sansa`` are added. The current goal is to select the most appropriate (and rarest) match using the following rules when multiple matches are identified in the gnomAD SV database:

1. Select a type-matched CNV (if possible), and the rarest type-matched variant from gnomAD SV (using AF) if there are multiple that match.

2. If none of the options are a type-match, select the rarest variant from gnomAD SV (using AF).

**Note**: CNV is a variant class in gnomAD SV, but not in the ``BIC-seq2`` output. Since DELs and DUPs are types of CNVs, we prioritize as follows: we first search for type-matches between DEL and DEL or DUP and DUP.  If a type-match is not found for the variant, we then search for type-matches between DEL and CNV or DUP and CNV. All other combinations (e.g., INV and CNV, or DEL and DUP) are considered to **not** be type-matched.

These rules were set given limitations on the number of values the gnomAD SV fields can have for filtering in the CGAP Portal and to avoid loss of rare variants in the upcoming filtering steps. The final output is a ``vcf`` file with annotations for both gene/transcript and gnomAD SV population frequencies. The resulting ``vcf`` file is checked for integrity.

Confidence classes
++++++++++++++++++

This step assigns a confidence class to each of the CNVs identified by the pipeline.

* CWL: BICseq2_add_confidence.cwl

Confidence classes are calculated and assigned using the ``add_confidence.py`` script.
A single VCF is required as input for the script. The file must store the information supporting each of the calls that is provided by ``BIC-seq2``.
The possible confidence classes are:

-	HIGH
-	LOW

The confidence classes are calculated based on the following parameters:

-	length: the length of the call calculated as an absolute value of the SVLEN parameter assigned to the call
-	log-ratio: the BICseq2_log2_copyRatio parameter calculated by BIC-Seq2

Each variant is classified based on the following criteria: 

High Confidence Calls
---------------------

.. code-block:: python

  length > 1 Mbp & (log-ratio > 0.4 || log-ratio < -0.8)

Low Confidence Calls
--------------------

All the other variants.


The calculated confidence classes are added as the new ``FORMAT`` field ``CF`` to the sample. The definition is added to the header:
.. code-block:: python

  ##FORMAT=<ID=CF,Number=.,Type=String,Description="Confidence class based on length and copy ratio (HIGH, LOW)">
