#!/bin/bash

zip_path=$1
telescope=$2
data_path=$(dirname $zip_path)
zip_file=$(basename $zip_path)
zip_name=$(basename $zip_file .zip)
html_path=$data_path/$zip_name.html

unzip -j -u $zip_path -d $data_path/$telescope
gunzip $data_path/$telescope/*.fts.gz

patterns=(`cat $html_path | sed -r 's/.*([0-9]{8})\.fts\s[0-9]+.*([0-9]{4}-[0-9]{2}-[0-9]{2}) ([0-9]{2}:[0-9]{2}:[0-9]{2}).*/\1 \2_\3/g' | sed -r 's/^.*[a-zA-Z].*$//g'`)

for i in $(seq 0 2 ${#patterns[@]})
do
  filename=$(echo ${patterns[$i + 1]} | sed 's/-//g' | sed 's/://g')_"$telescope"L.fts
  mv $data_path/$telescope/${patterns[$i]}.fts $data_path/$filename
done

