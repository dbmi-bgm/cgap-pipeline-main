===================
*de novo* Mutations
===================

This step uses ``granite novoCaller`` to call *de novo* mutations for a trio (**proband**, mother and father).
The software uses allele counts information for the trio and a panel of unrelated samples to assigning a posterior probability to each variant called.
The output ``vcf`` file is checked for integrity to ensure the format is correct and the file is not truncated.

* CWL: workflow_granite-novoCaller-rck_plus_vcf-integrity-check.cwl


Requirements
++++++++++++

The input is a ``vcf`` file and must contain genotype information for both the proband and the parents.
The software also requires two ``.rck.tar`` files, one for the trio and one for a panel of unrelated individuals.
The ``.rck.tar`` files are tarballs of ``.rck`` files that are created from corresponding ``bam`` files to record allele-specific and strand-specific read counts.


Output
++++++

The step creates an output ``vcf`` file that contains the same variants as the input file (no line is removed), but with additional information added by the caller (``novoPP`` and ``RSTR``).

An example:

::

    chr1  1041200 .    C    T    573.12 .    AC=2;AF=0.333;AN=6;BaseQRankSum=0.408;DP=76;ExcessHet=3.01;FS=3.873;MLEAC=2;MLEAF=0.333;MQ=60.00;MQRankSum=0.00;QD=13.65;ReadPosRankSum=0.155;SOR=1.877;gnomADgenome=7.00849e-06;SpliceAI=0.11;VEP=ENSG00000188157|ENST00000379370|Transcript|missense_variant|AGRN|protein_coding;novoPP=0.0  GT:AD:DP:GQ:PL:RSTR   0/1:9,4:13:99:100,0,248:6,5,4,2 0/0:34,0:34:96:0,96,1440:23,0,11,0   0/1:12,17:29:99:484,0,309:12,17,2,4   ./.:.:.:.:.:29,0,20,0  ./.:.:.:.:.:19,0,16,0  ./.:.:.:.:.:16,1,22,0  ./.:.:.:.:.:21,0,18,0  ./.:.:.:.:.:28,0,22,0  ./.:.:.:.:.:20,0,24,0  ./.:.:.:.:.:21,0,26,0  ./.:.:.:.:.:11,0,11,0  ./.:.:.:.:.:15,0,13,0  ./.:.:.:.:.:29,0,22,0

novoPP
------

The ``novoPP`` tag is added to the INFO field of each variants and stores the posterior probability calculated for the variant (0 < novoPP <= 1).
A high novoPP value suggests that the variant is likely to be a *de novo* mutation in the proband.

RSTR
----

The ``RSTR`` value is added to each sample genotype and stores the corresponding reads counts by strand at position for reference and alternate alleles used by the caller as ``Rf,Af,Rr,Ar`` (R: ref, A: alt, f: forward, r: reverse).


FAQ
+++

1. Does this step handle both SNVs and indels?

  | Yes

2. What does novoPP=0 mean?

  | novoPP=0 means that the parents had 3 or more ALTernate reads and the posterior probability was not calculated. It means that the variant is highly unlikely to be a *de novo* mutation.

3. How does it work for chrX, Y, or M?

  | Currently we do not report novoPP for chrX, Y, or M, except when novoPP=0. This is because the model used by novoCaller does not fit well with unbalanced chromosomes.
