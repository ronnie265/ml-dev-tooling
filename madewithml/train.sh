#!/bin/bash -e

export EXPERIMENT_NAME="llm"
export DATASET_LOC="https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/dataset.csv"
export TRAIN_LOOP_CONFIG='{"dropout_p": 0.5, "lr": 1e-4, "lr_factor": 0.8, "lr_patience": 3}'
python madewithml/train.py \
    --experiment-name "$EXPERIMENT_NAME" \
    --dataset-loc "$DATASET_LOC" \
    --train-loop-config "$TRAIN_LOOP_CONFIG" \
    --num-workers 8 \
    --cpu-per-worker 1 \
    --gpu-per-worker 0 \
    --num-epochs 10 \
    --batch-size 256 \
    --results-fp results/training_results.json
