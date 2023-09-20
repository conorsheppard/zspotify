#!/bin/sh

find_duplicates_with_tmp_file() {
    # dirname=$(pwd | sed 's/ /\\ /g')
    dirname="/Volumes/SANDISK 2/ZSpotify Music"
    tempfile=myTempfileName
    find $dirname -type f > $tempfile
    cat $tempfile | sed 's_.*/__' | sort |  uniq -d| 
    while read fileName
    do
     grep "/$fileName" $tempfile
    done
    #rm -f $tempfile
}

find_duplicates() {
    # dirname="$(pwd | sed 's/ /\\ /g')"
    dirname="$(pwd)"
    find "$dirname" -type f | sed 's_.*/__' | sort|  uniq -d| 
    while read fileName
    do
    find "$dirname" -type f | grep "$fileName"
    done
}

# find_duplicates_with_tmp_file

find_duplicates