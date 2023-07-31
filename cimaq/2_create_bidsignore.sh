#!/bin/bash

cd /lustre04/scratch/nclarke/CIMAQ

cat <<EOF > .bidsignore
changelog.txt
dictionnaire_de_données.tsv
demographie_et_diagnostic_initial.tsv

EOF

echo 'Done!'
