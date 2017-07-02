#!/usr/bin/bash

if [ $# -eq 0 ]
then
    echo "usage: bash $0 </path/to/image/or/video>"
    exit
fi

TYPE="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=nokey=1:noprint_wrappers=1 $1)"

echo $TYPE

function predict_image() {
    
}

if [[ $TYPE == h* ]] # input is video
then
    #ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1
else
    # curl right away
fi


