#!/bin/bash

cd `dirname $0`
GDIR=../GloVe-1.2/
W2VGDIR=../word2vec-graph/

# subreddit name; e.g. randonauts or randonaut_reports
sub=$1

# get latest subreddit text
python3.7 getSubData.py $sub

# make lowercase and move
cd redditData/
tr '[:upper:]' '[:lower:]' < ${sub}.csv > ${sub}_lowercase.csv
rm ${sub}.csv
mv ${sub}_lowercase.csv ${sub}.csv
cp ${sub}.csv ../$GDIR
cd ..

cd $GDIR 

#
# from glove's demo.sh
#
CORPUS=${sub}.csv
VOCAB_FILE=vocab.txt
COOCCURRENCE_FILE=cooccurrence.bin
COOCCURRENCE_SHUF_FILE=cooccurrence.shuf.bin
BUILDDIR=build
SAVE_FILE=vectors
VERBOSE=2
MEMORY=0.5
VOCAB_MIN_COUNT=1
VECTOR_SIZE=$2
MAX_ITER=25
WINDOW_SIZE=25
BINARY=2
NUM_THREADS=2
X_MAX=10

$BUILDDIR/vocab_count -min-count $VOCAB_MIN_COUNT -verbose $VERBOSE < $CORPUS > $VOCAB_FILE
if [[ $? -eq 0 ]]
  then
  $BUILDDIR/cooccur -memory $MEMORY -vocab-file $VOCAB_FILE -verbose $VERBOSE -window-size $WINDOW_SIZE < $CORPUS > $COOCCURRENCE_FILE
  if [[ $? -eq 0 ]]
  then
    $BUILDDIR/shuffle -memory $MEMORY -verbose $VERBOSE < $COOCCURRENCE_FILE > $COOCCURRENCE_SHUF_FILE
    if [[ $? -eq 0 ]]
    then
       $BUILDDIR/glove -save-file $SAVE_FILE -threads $NUM_THREADS -input-file $COOCCURRENCE_SHUF_FILE -x-max $X_MAX -iter $MAX_ITER -vector-size $VECTOR_SIZE -binary $BINARY -vocab-file $VOCAB_FILE -verbose $VERBOSE
       if [[ $? -eq 0 ]]
       then
	   echo GloVe done
           #if [ "$1" = 'matlab' ]; then
               #matlab -nodisplay -nodesktop -nojvm -nosplash < ./eval/matlab/read_and_evaluate.m 1>&2 
           #elif [ "$1" = 'octave' ]; then
               #octave < ./eval/octave/read_and_evaluate_octave.m 1>&2 
           #else
               #python eval/python/evaluate.py
           #fi
       fi
    fi
  fi
fi

#
# EOF from glove's demo.sh
#

#
# word2vec-graph work
#
mkdir ~/word2vec-graph/${sub}-graph-data/
rm -rf ~/word2vec-graph/${sub}-graph-data/*
cp ${SAVE_FILE}.txt ~/word2vec-graph/${sub}-graph-data/

mkdir ~/word2vec-graph/${sub}-graph-layout/
rm -rf ~/word2vec-graph/${sub}-graph-layout/*

cd ~/word2vec-graph/

python save_text_edges.py --input_vectors ${sub}-graph-data/${SAVE_FILE}.txt --out_file ${sub}-graph-data/edges.txt --dimensions $VECTOR_SIZE 
node ${sub}-edges2graph.js ${sub}-graph-data/edges.txt
node --max-old-space-size=2000 ${sub}-layout.js

#
# copy to pm - the galaxy nodejs package that shows us pretty stuff
#
rm -rf ../fatumemeplex/build/data/${sub}/2019-10-31T00-00-00Z/*
cp -rf ${sub}-graph-data/* ${sub}-graph-layout/* ../fatumemeplex/build/data/${sub}/2019-10-31T00-00-00Z

echo ALL DONE MEz THINKS
