#!/bin/bash

mkdir ${SCRATCH}/adhd200
cd ${SCRATCH}/adhd200
datalad install -r -g -s ///adhd200/RawDataBIDS .
