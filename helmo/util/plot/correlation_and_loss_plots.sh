#!/usr/bin/env bash

# This script is for drawing a plot with steps on
# horizontal axis and correlation on vertical axis.
# Plot data is created and put in the same directory with
# plot.

# Args:
#   1. string of artist labels separated by at signs
#   2. string of experiment result dirs separated by at signs
#   3. path to dir where results will be stored
#   4. error style
#   sorting_key: definition of a function for sorting lines in plot_data

function main () {
  if test -z "$4"
  then
    local err_style="fill"
  else
    local err_style="$4"
  fi

  if test -z "${sorting_key}"
  then
    local sorting_str=""
    local corr_exec_scr_str=""
    local loss_exec_scr_str=""
  else
    local sorting_str="-k=${sorting_key}"
    local corr_exec_scr_str="-e=$3/corr_plot_data_exec.py"
    local loss_exec_scr_str="-e=$3/loss_plot_data_exec.py"
  fi

  oldIFS="$IFS"
  IFS="@"
  local labels=($1)
  local exp_dirs=($2)

  IFS="${oldIFS}"

  mkdir -p $3
  local -a mean_corr
  local -a err_corr
  local -a step_corr
  local -a loss_files
  local exp_dir
  for exp_dir in "${exp_dirs[@]}"
  do
    mean_corr+=("${exp_dir}/mean/corr/mean.pickle")
    err_corr+=("${exp_dir}/mean/corr/stddev.pickle")
    step_corr+=("${exp_dir}/0/results/loss_valid.txt")
    loss_files+=("${exp_dir}/mean/loss.txt")
  done
#  echo "${#labels[@]}"
#  echo "${#step_corr[@]}"
#  echo "${#mean_corr[@]}"
#  echo "${#err_corr[@]}"
#  echo "${sorting_str}"
#  for lbl in "${labels[@]}"
#  do
#    echo $lbl
#  done
  python3 ${PLOT}/plot_data_from_pickle.py -l "${labels[@]}" -s "${step_corr[@]}" \
    -m "${mean_corr[@]}" -d "${err_corr[@]}" -n -o $3/corr_plot_data.pickle \
    ${sorting_str:+"$sorting_str"}
  python3 ${PLOT}/plot_from_pickle.py $3/corr_plot_data.pickle -x step -y "mean square correlation" \
    -X symlog -o $3/corr_plot -t ${err_style} -d best -O -s png -r 900 -g -w both \
    ${corr_exec_scr_str:+$corr_exec_scr_str} ${lw_params:+"${lw_params[@]}"}
  python3 ${PLOT}/plot_data_from_txt.py "${loss_files[@]}" -l "${labels[@]}" -x 0 -y 1 -e 2 \
    -o $3/loss_plot_data.pickle ${sorting_str:+"$sorting_str"} -n
  python3 ${PLOT}/plot_from_pickle.py $3/loss_plot_data.pickle -x step -y loss \
    -X symlog -o $3/loss_plot -t ${err_style} -d best -O -s png -r 900 -g -w both \
    ${loss_exec_scr_str:+$loss_exec_scr_str} ${lw_params:+"${lw_params[@]}"}
}


main "$1" "$2" "$3" "$4"
unset main
