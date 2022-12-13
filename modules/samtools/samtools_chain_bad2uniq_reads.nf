process CHAIN_BAD2UNIQ_READS {
  tag "$sampleID"

  cpus 1
  memory 4.GB
  time '04:00:00'

  container 'quay.io/jaxcompsci/samtools_with_bc:1.3.1'

  input:
  tuple val(sampleID), file(bad_reads)

  output:
  tuple val(sampleID), file("ReadName_unique"), emit: uniq_reads
  
  when: params.chain != null

  shell:
  log.info "----- Getting 'bad reads' from bam file on ${sampleID} -----"
  // Get unique 'bad read names' from bam file using gatk ValidateSamFile out results
  '''
  cat !{bad_reads} \
  | awk '{print $5}' \
  | sed -r 's/\\,//g' \
  | sort -n \
  | uniq -c \
  | awk '{print $2}' \
  > ReadName_unique
  '''
}
