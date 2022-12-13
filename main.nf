#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// import workflow of interest
if (params.workflow == "calm"){
  include {CALM} from './workflows/calm'
}
if (params.workflow == "wes"){
  include {WES} from './workflows/wes'
}
if (params.workflow == "wgs"){
  include {WGS} from './workflows/wgs'
}
// conditional to kick off appropriate workflow
workflow{
  if (params.workflow == "calm"){
    CALM()
    }
  if (params.workflow == "wes"){
    WES()
    }
  if (params.workflow == "wgs"){
    WGS()
    }
}
