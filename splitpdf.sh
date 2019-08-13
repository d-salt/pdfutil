#! /usr/bin/env bash

function croppdf () {
    file=$1
    file_name="$(basename $file)"
    file_name=${file_name%.*}

    # set page size
    read org_width org_height <<< $(pdfinfo $file | grep 'Page size:' | awk '{print int($3+0.5), int($5+0.5)}')
    target_width=$(($org_width / 2))
    target_height=$org_height

    # crop left page
    pdftocairo $file -pdf -nocrop -x 0 -y 0 -W $target_width -H $target_height -paperw $target_height -paperh $target_width ${input_file_name}/cropped/${file_name}.left.pdf

    # crop right page
    pdftocairo $file -pdf -nocrop -x $target_width -y 0 -W $target_width -H $target_height -paperw $target_height -paperh $target_width ${input_file_name}/cropped/${file_name}.right.pdf
}


###
# main script
###

input_file=$1
input_file_name=$(basename $input_file)
input_file_name=${input_file_name%.*}
output_file=${input_file_name}.split.pdf

# set working dir
cd $(dirname $0)
# make working dir
mkdir -p ${input_file_name}/split && mkdir -p ${input_file_name}/cropped

# separate each page
pdfseparate $input_file ${input_file_name}/split/%d.pdf

# crop each page
for pdf in ${input_file_name}/split/*.pdf
do
    if [ -f "$pdf" ]; then
        croppdf $pdf
    else
        continue

    fi
done

# unite hole page
pdfunite $(ls ${input_file_name}/cropped/ | sort -n | xargs printf '${input_file_name}/cropped/%s\n') $output_file

# rm working files
rm -rf ${input_file_name}/split ${input_file_name}/cropped

exit 0
