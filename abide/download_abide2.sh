#!/bin/bash

SCRATCH_PATH="/lustre04/scratch/${USER}"

mkdir -p ${SCRATCH_PATH}/abide2
cd ${SCRATCH_PATH}/abide2
datalad install -r -g -s ///abide2/RawData .
