#!/bin/bash

if [ $# -eq 0 ]
then
    echo "usage: bash $0 </path/to/image/or/video>"
    exit
fi

TYPE="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=nokey=1:noprint_wrappers=1 $1)"

function predict_image() {
    IMGDATA="$(base64 $1)"
    RESPONSE="$(curl -s --compressed -H 'Host:whatanime.ga' -H 'Connection:keep-alive' -H 'Content-Length:32263' -H 'Accept:application/json, text/javascript, */*; q=0.01' -H 'Origin:https://whatanime.ga' -H 'X-Requested-With:XMLHttpRequest' -H 'User-Agent:Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36' -H 'Content-Type:application/x-www-form-urlencoded; charset=UTF-8' -H 'Referer:https://whatanime.ga/' -H 'Accept-Encoding:gzip, deflate, br' -H 'Accept-Language:en-US,en;q=0.8' -H 'Cookie:__cfduid=da48fd4d73834538d42affa006a05bfa11499054832; _ga=GA1.2.460445586.1499054837; _gid=GA1.2.285369962.1499054837; ext_name=jaehkpjddfdgiiefcnhahapilbejohhj; __lnkrntdmcvrd=-1' -X POST 'https://whatanime.ga/search' --data-urlencode "data=data:image/jpeg;base64,$IMGDATA" --data-urlencode 'filter=*' --data-urlencode 'trial=4')"
    echo $RESPONSE | rev | cut -d'"' -f 2 | rev
}

if [[ $TYPE == h* ]] # input is video
then
    for i in {10..30};
    do
        ffmpeg -hide_banner -nostats -v panic -accurate_seek -ss `echo $i*60.0 | bc` -i $1 -frames:v 1 frame_$i.jpg;
        predict_image frame_$i.jpg;
        rm frame_$i.jpg;
    done
else
    predict_image $1
fi
