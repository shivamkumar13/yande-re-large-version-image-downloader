#! /bin/bash

# to change permission
# chmod +X <filename.sh>


curl=$(which curl)
# outfile="url.txt"
# regex="lazyload effect-fade"
# manga_id="manga_5bf3793e73db1"
page_url=$1
# manga_name=$2
# last_chapter=$3
# chapter_number=0
# chapter_array={01..$end_chapter}


#pages url in out.txt
function find_image_pages_url_list(){
	$curl -s -o  out.txt $page_url
	grep -h -e "https://yande.re/post/show/" out.txt | sed 's/http/\nhttp/g' | grep ^http | sed 's/\(^http[^ <]*\)\(.*\)/\1/g' | grep "post/show" > page_url.txt
	rm out.txt
}

function prepare_images_url_list(){
 for i in $(cat page_url.txt)
 	do 
 		curl -s "$i" > file.txt
 		find_images_url
 		printf "."
 	done
 echo ""
 echo "IMAGE LIST FORMED"
 echo ""
}

#image on page in url.txt
function find_images_url(){
	grep -h -e "original-file-changed" file.txt | grep "Download" |sed 's/http/\nhttp/g' | grep ^http | sed 's/\(^http[^ <]*\)\(.*\)/\1/g'| sed 's/">.*//p' >> images.txt
}

function download_images(){
	echo "Downloading Images ........................"
	wget -qNi images.txt --show-progress
	printf "\nTOTAL IMAGES: %s\n" "$(grep -h -e "http" images.txt | wc -l )"
}


#================== MAIN ===============================

echo "Script START ====================================="
printf "PAGE: %s\n" "$1"
find_image_pages_url_list
prepare_images_url_list
download_images
rm file.txt
rm page_url.txt
rm images.txt
echo "Script END ======================================="