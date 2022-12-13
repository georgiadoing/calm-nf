process TRIMMOMATIC_TRIM {
  publishDir "${params.pubdir}/trimmed"
  container "quay.io/biocontainers/trimmomatic:0.35--6"

  input:
  tuple val(sampleId), file(reads)

  output:
  tuple val(sampleId), file('*R1_paired.fastq.gz'), file('*R2_paired.fastq.gz')

  script:
  log.info "----- Trimmomatic Running on: ${sampleID} -----"
  """
  trimmomatic \
  PE \
  ${params.sample_folder}/${reads[1]} \
  ${params.sample_folder}/${reads[0]} \
  ${sampleId}_R2_paired.fastq.gz \
  ${sampleId}_R1_paired.fastq.gz \
  LEADING:${params.t_lead} \
  TRAILING:${params.t_trail} \
  MINLEN:${params.min_len}
  """

}
