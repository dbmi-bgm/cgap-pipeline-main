=========
md5 Check
=========

All files that are uploaded to the CGAP Portal, including reference files, input files, and all files generated throughout the bioinformatics pipelines undergo an md5 check (using ``run.sh`` in the md5 docker folder) to ensure that the upload was successful and has produced an identical file (no download interruption or other forms of file truncation).

* CWL: md5.cwl
