process FINAL_CALC_FRIP {
  tag "$sampleID"

  cpus  1
  memory 4.GB
  time '04:00:00'

  publishDir "${params.pubdir}/${ params.organize_by=='sample' ? sampleID+'/stats' : 'samtools' }", pattern: "*_Fraction_reads_in_peak.txt", mode: 'copy'
  container 'quay.io/jaxcompsci/samtools_with_bc:1.3.1'

  input:
  tuple val(sampleID), file(processed_bams), file(reads_peaks_bams)

  output:
  tuple val(sampleID), file("*_Fraction_reads_in_peak.txt")

  shell:
  log.info "----- Final Calculate (FRiP) on ${sampleID} -----"
  // Calculate fraction of reads in peak
  '''
  total_reads=$(samtools view -c !{processed_bams[0]})
  reads_in_peaks=$(samtools view -c !{reads_peaks_bams[0]})
  FRiP=$(awk "BEGIN {print "${reads_in_peaks}"/"${total_reads}"}")
  echo -e ${FRiP}"\\t"${total_reads} \
  > !{sampleID}_Fraction_reads_in_peak.txt
  '''
}
