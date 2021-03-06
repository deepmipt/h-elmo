#!/usr/bin/env bash

# The script is for computing mean correlation
# and mean loss. Standard deviation is also computed


function average_correlation () {
  local current_dir=$(pwd)
  cd $1
  mkdir -p mean/corr
  local pickle_files=()
  for launch in $(ls | grep -E '^(0|[1-9][0-9]*)$'); do
    pickle_files+=(${launch}/tensors/valid/pickle_mean_tensors/correlation.pickle)
  done
  python3 ~/h-elmo/helmo/util/scripts/average_pickle_values.py ${pickle_files[@]} --preprocess $2 \
    --mean mean/corr/mean.pickle --stddev mean/corr/stddev.pickle --stderr_of_mean mean/corr/stderr_of_mean.pickle
  cd ${current_dir}
}


function average_loss () {
  local current_dir=$(pwd)
  cd $1
  mkdir -p mean
  local loss_files=()
  for launch in $(ls | grep -E '^(0|[1-9][0-9]*)$'); do
    loss_files+=(${launch}/results/loss_valid.txt)
  done
  python3 ~/h-elmo/helmo/util/scripts/average_txt.py ${loss_files[@]} -o mean/loss.txt
  cd ${current_dir}
}


echo "  computing average for $1"
current_dir=$(pwd)
cd $1
average_correlation "." "np.sqrt({array})"
average_loss "."
cd ${current_dir}
unset current_dir
unset average_correlation
unset average_loss
