#!/bin/bash

for file in $(find . -name "*.epub"); do
    echo ${file}

    filename=${file%.epub}
    filename=${filename#./}
    # echo ${filename}

    tmpPath=./${filename}
    # echo ${tmpPath}

    zipPath=${tmpPath}.tempzip
    # echo ${zipPath}

    if [ ! -f "${tmpPath}" ]; then
        mkdir ${tmpPath}
    fi

    if [ ! -f "${zipPath}" ]; then
        mkdir ${zipPath}
    fi

    unzip -d ${tmpPath} ${file} >/dev/null

    htmlPath="${tmpPath}/html"
    index=1
    while ([ -f "./${htmlPath}/$index.html" ]); do
        # echo ${htmlPath}/$index.html
        IMGURL=$(cat ${htmlPath}/${index}.html | grep img | cut -d '"' -f 2)
        # echo ${IMGURL}

        oldImgPath=${tmpPath}/${IMGURL#../}

        array=(${oldImgPath//./ })
        typeName=${array[${#array[@]} - 1]}
        newImgPath=${zipPath}/$(echo ${index} | awk '{printf("%05d",$0)}').${typeName}

        mv ${oldImgPath} ${newImgPath}

        index=$(($index + 1))
    done

    cd ${zipPath}
    zip -q ../${filename}.zip *
    cd ..

    rm -rf ${tmpPath}
    rm -rf ${zipPath}

    echo ${zipPath}.zip
done