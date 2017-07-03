#!/usr/bin/bash

if [ $# -eq 0 ]
then
    echo "usage: bash $0 </path/to/image/or/video>"
    exit
fi

TYPE="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=nokey=1:noprint_wrappers=1 $1)"

echo $TYPE

function predict_image() {
    IMGDATA="$(base64 $1)"
    RESPONSE="$(curl -H 'Host:whatanime.ga' -H 'Connection:keep-alive' -H 'Content-Length:32263' -H 'Accept:application/json, text/javascript, */*; q=0.01' -H 'Origin:https://whatanime.ga' -H 'X-Requested-With:XMLHttpRequest' -H 'User-Agent:Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36' -H 'Content-Type:application/x-www-form-urlencoded; charset=UTF-8' -H 'Referer:https://whatanime.ga/' -H 'Accept-Encoding:gzip, deflate, br' -H 'Accept-Language:en-US,en;q=0.8' -H 'Cookie:__cfduid=da48fd4d73834538d42affa006a05bfa11499054832; _ga=GA1.2.460445586.1499054837; _gid=GA1.2.285369962.1499054837; ext_name=jaehkpjddfdgiiefcnhahapilbejohhj; __lnkrntdmcvrd=-1' -X POST 'https://whatanime.ga/search' --data-urlencode "data=data:image/jpeg;base64,$IMGDATA" --data-urlencode 'filter=*' --data-urlencode 'trial=4')"

    echo $RESPONSE
}

if [[ $TYPE == h* ]] # input is video
then
    echo "heh"
    #ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1
else
    predict_image $1
    # curl right away
fi


