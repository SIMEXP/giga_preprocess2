#!/bin/bash

cd /lustre04/scratch/nclarke/CIMAQ

input_file="demographie_et_diagnostic_initial.tsv"
output_file="participants.tsv"

cp "$input_file" "$output_file"
sed -i '1s/PSCID/participant_id/' "$output_file"

# Fill empty cells with "n/a"
awk 'BEGIN{FS=OFS="\t"} {for(i=1;i<=NF;i++) if($i=="") $i="n/a"} 1' "$output_file" > "$output_file.tmp"
mv "$output_file.tmp" "$output_file"

echo 'Done!'
