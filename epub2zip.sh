#!/bin/bash

for file in $(find . -name "*.epub"); do
    echo ${file}

    filename=${file%.epub}
    filename=${filename#./}
    # echo ${filename}

    tmpPath=./${filename}
    # echo ${tmpPath}

    zipPath=${tmpPath}
    # echo ${zipPath}

    if [ ! -f "${tmpPath}" ]; then
        mkdir ${tmpPath}
    fi

    if [ ! -f "${zipPath}" ]; then
        mkdir ${zipPath}
    fi

    unzip -d ${tmpPath} ${file} > /dev/null

    htmlPath="${tmpPath}/html"
    index=1 
    while ([ -f "./${htmlPath}/$index.html" ]); do
        # echo ${htmlPath}/$index.html
        IMGURL=$(cat ${htmlPath}/${index}.html | grep img | cut -d '"' -f 2)
        # echo ${IMGURL}

        oldImgPath=${tmpPath}/${IMGURL#../}
        newImgPath=${zipPath}/${index}.jpg
        cp ${oldImgPath} ${newImgPath}

        index=$(($index + 1))
    done

    zip -rq ${filename}.zip ${zipPath}/

    rm -rf ${tmpPath}
    rm -rf ${zipPath}

    echo ${zipPath}.zip
done
