process TRIM_FASTQ {
  cpus 8
  memory 10.GB
  time '20:00:00'

  publishDir "${params.pubdir}/${ params.organize_by=='sample' ? sampleID+'/stats' : 'cutadapt' }", pattern: "*.log", mode: 'copy'
  container 'quay.io/biocontainers/cutadapt:2.3--py37h14c3975_0'

  input:
  tuple val(sampleID), file(fq_reads)

  output:
  tuple val(sampleID), file("*paired_trimmed.fq"), emit: paired_trimmed_fastq
  tuple val(sampleID), file("*.log"), emit: cutadapt_log

  script:
  log.info "----- Cutadapt Running on: ${sampleID} -----"

  paired_end = params.read_type == 'PE' ?  "-p ${sampleID}_R2_paired_trimmed.fq" : ''

  """
  cutadapt \
  -a ${params.cutadaptAdapterR1} \
  -A ${params.cutadaptAdapterR2} \
  --minimum-length ${params.cutadaptMinLength} \
  --quality-cutoff ${params.cutadaptQualCutoff} \
  -j $task.cpus \
  -o ${sampleID}_R1_paired_trimmed.fq \
  ${paired_end} \
  ${fq_reads} \
  > ${sampleID}_cutadapt.log \
  2>&1
  """

}
