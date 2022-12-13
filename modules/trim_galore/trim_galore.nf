process TRIM_GALORE {
  tag "$sampleID"

  cpus 8
  memory 16.GB
  time '06:00:00'

  container 'quay.io/biocontainers/trim-galore:0.6.7--hdfd78af_0'
  publishDir "${params.pubdir}/${ params.organize_by=='sample' ? sampleID+'/trimmed_fastq' : 'trim_galore' }", pattern: "*.fq.gz", mode:'copy'
  publishDir "${params.pubdir}/${ params.organize_by=='sample' ? sampleID+'/stats' : 'fastqc' }", pattern: "*_fastqc.{zip,html}", mode:'copy'
  publishDir "${params.pubdir}/${ params.organize_by=='sample' ? sampleID+'/stats' : 'trim_report' }", pattern: "*trimming_report.txt", mode:'copy'

  input:
  tuple val(sampleID), file(fq_reads)

  output:
  tuple val(sampleID), file("*_fastqc.{zip,html}"), emit: trimmed_fastqc
  tuple val(sampleID), file("*.fq.gz"), emit: trimmed_fastq
  tuple val(sampleID), file("*trimming_report.txt"), emit: trim_stats

  script:
  log.info "----- Trim Galore Running on: ${sampleID} -----"

  paired_end = params.read_type == 'PE' ?  '--paired' : ''
  rrbs_flag = params.workflow == "rrbs" ? '--rrbs' : ''
  /*
  RRBS Mode
  In this mode, Trim Galore identifies sequences that were adapter-trimmed and removes another 2 bp from the 3' end of Read 1, 
  and for paired-end libraries also the first 2 bp of Read 2 (which is equally affected by the fill-in procedure). 
  This is to avoid that the filled-in cytosine position close to the second MspI site in a sequence is used for methylation calls. 
  Sequences which were merely trimmed because of poor quality will not be shortened any further.
  */
  directionality = params.non_directional ? '--non_directional': ''
  /*
  Non-directional mode
  The non-directional option, will screen adapter-trimmed sequences for the presence of either CAA or CGA at the start of sequences
  and clip off the first 2 bases if found. If CAA or CGA are found at the start, no bases will be trimmed off from the 3’ end 
  even if the sequence had some contaminating adapter sequence removed   in this case the sequence read likely originated from either the CTOT or CTOB strand; 
  refer to the RRBS guide for the meaning of CTOT and CTOB strands). 
  */

  """
    trim_galore --basename ${sampleID} --cores ${task.cpus} ${paired_end} ${rrbs_flag} ${directionality} --gzip --length ${params.trimLength} -q ${params.qualThreshold}  --stringency ${params.adapOverlap}  -a ${params.adaptorSeq}  --fastqc ${fq_reads}
  """
}

