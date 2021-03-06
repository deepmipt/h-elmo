#!/usr/bin/env bash

source ~/.bashrc

dpenv

setdev 0

tt=("$HOME/h-elmo/tests/experiments/logarithmic_controller.json" \
    "$HOME/h-elmo/tests/experiments/correlation/nocorrloss/batch_mean/100_100short.json" \
    "$HOME/h-elmo/tests/experiments/correlation/nocorrloss/overfitting/validate_on_train.json" \
    "$HOME/h-elmo/tests/experiments/residual/nocorrloss/batch_mean/100_100short.json" \
    "$HOME/h-elmo/tests/experiments/residual/nocorrloss/overfitting/validate_on_train.json" \
    "$HOME/h-elmo/tests/experiments/resrnn/no_matrix_dim_adjustment.json" \
    "$HOME/h-elmo/tests/experiments/resrnn/matrix_dim_adjustment.json" \
    "$HOME/h-elmo/tests/experiments/residual/straight1.json" \
    "$HOME/h-elmo/tests/experiments/entropy/20.json" \
    "$HOME/h-elmo/tests/experiments/entropy/post_processing.json" \
    "$HOME/h-elmo/tests/experiments/residual/half_residual.json" \
    "$HOME/h-elmo/tests/experiments/residual/averaging.json" \
    "$HOME/h-elmo/tests/experiments/accumulators.json" \
    "$HOME/h-elmo/tests/experiments/residual/normalizing.json")

hs=("$HOME/h-elmo/tests/experiments/resrnn/small/char/hp/200.json" \
    "$HOME/h-elmo/tests/experiments/resrnn/residual/200.json")

for config in ${tt[@]}; do
  echo "*******************************"
  echo "*******************************"
  echo "Processing" $config
  python3 $TT $config --test --no_logging
done

for config in ${hs[@]}; do
  echo "Processing" $config
  python3 $HS $config --test --no_logging
done

python3 $HH/util/plot/plot_from_pickle.py ~/h-elmo/tests/plot/loss_plot_data.pickle -y loss -X log -t fill -d upper_right -O -g -o ~/h-elmo/testres/plot/loss_plot -r 900
