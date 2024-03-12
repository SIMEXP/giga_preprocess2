#!/bin/bash
#SBATCH --account=def-pbellec
#SBATCH --time=02:00:00
#SBATCH --mem=4G

module load python

python 1_reorganise.py

