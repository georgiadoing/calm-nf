process NON_CHAIN_REINDEX {
  tag "$sampleID"

  cpus  1
  memory 8.GB
  time '10:00:00'

  publishDir "${params.pubdir}/${ params.organize_by=='sample' ? sampleID+'/bam' : 'samtools' }", pattern: "*.filtered.shifted.*", mode: 'copy'
  container 'quay.io/jaxcompsci/samtools_with_bc:1.3.1'

  input:
  tuple val(sampleID), file(bam_shifted)

  output:
  tuple val(sampleID), file("*.filtered.shifted.*")

  when: params.chain == null

  script:
  log.info "----- Filtering Mitochondrial, Unplaced/Unlocalized Reads and reindex on ${sampleID} -----"
  // This module is for Reference Strain Samples.
  // To filter Mitochondrial, Unplaced/Unlocalized Reads from bam file.
  """
  samtools index ${bam_shifted[0]}

  # filter Mitochondrial, Unplaced/Unlocalized Reads
  samtools view ${bam_shifted[0]} \
  -h 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 X Y \
  | grep -ve 'SN:MT*\\|SN:GL*\\|SN:JH:*' > tmp.sam

  samtools view -b tmp.sam \
  > ${sampleID}.sorted.rmDup.rmChrM.rmMulti.filtered.shifted.mm10.bam

  samtools index \
  ${sampleID}.sorted.rmDup.rmChrM.rmMulti.filtered.shifted.mm10.bam
  """
}
