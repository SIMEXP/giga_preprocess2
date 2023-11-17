#!/bin/bash

OPENNEURO_PATH="/lustre04/scratch/${USER}/openneuro"
DATASET="ds000030"

mkdir -p ${OPENNEURO_PATH}
echo "Get ${DATASET}"
cd ${OPENNEURO_PATH}
datalad install https://github.com/OpenNeuroDatasets/${DATASET}.git
cd /lustre04/scratch/${USER}/openneuro/ds000030
datalad get -r .
