#!/bin/sh

function getpath {
    ___p=$(pwd)
    cd $(dirname $1) && pwd && cd ${___p}
}

function xslt {
    saxonb-xslt -xsl:$1 -s:$2 -o:$3

}

function usage {
    echo ""
    echo "requires saxon and dotty:"
    echo "       sudo aptitude install libsaxonb-java graphviz"
    echo "usage:"
    echo "       $0 mypipeline.xml"
    echo "       $0 -svg myoutput.svg mypipeline.xml"
    echo "       $0 --help"
}

function missing {
    if which $1 > /dev/null
    then
        false
    else
        echo Error: $1 not found
        true
    fi
}

test \( $# = 0 \) -o \( x$1 = x--help \) && usage && exit
missing saxonb-xslt && usage && exit
missing dotty && usage && exit

exepath=$(getpath $0)
svg=
if test "x$1" = x-svg
then
    shift
    svg=$1
    if echo "${svg}" | egrep -v -q -e '[.]svg$'
    then
        usage && exit
    fi
    shift
fi

inpath=$(getpath $1)
out=/tmp/pipeline-$((echo ${inpath}/$(basename $1)) | sed 's@/@-@g').dot

test $1 -nt ${out} && xslt ${exepath}/view-pipeline.xsl $1 ${out}
echo "dot file is: $out"
#cat ${out}
if test "x$svg" = x
then
    dotty ${out}
else
    echo "svg file is: $svg"
    dot -Tsvg -o ${svg} ${out}
fi
