#!/bin/bash

SCRATCH_PATH="/lustre04/scratch/${USER}"

mkdir -p ${SCRATCH_PATH}/abide
cd ${SCRATCH_PATH}/abide
datalad install -r -g -s ///abide/RawDataBIDS .
