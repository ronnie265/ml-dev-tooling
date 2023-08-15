FROM python:3.10.12-slim

ENV WORKDIR=/app/ml-dev-tooling
ENV PYTHONPATH $PYTHONPATH:$WORKDIR

WORKDIR $WORKDIR

COPY poetry.lock pyproject.toml $WORKDIR/
RUN pip install "poetry==1.4.1"
RUN poetry install --no-interaction

COPY madewithml $WORKDIR/madewithml
COPY datasets $WORKDIR/datasets

ENV EXPERIMENT_NAME="llm"
ENV RESULTS_FILE=$WORKDIR/results/training_results.json
ENV DATASET_LOC=$WORKDIR/datasets/dataset.csv
ENV TRAIN_LOOP_CONFIG='{"dropout_p": 0.5, "lr": 1e-4, "lr_factor": 0.8, "lr_patience": 3}'

RUN python $WORKDIR/madewithml/train.py \
    --experiment-name "$EXPERIMENT_NAME" \
    --dataset-loc "$DATASET_LOC" \
    --train-loop-config "$TRAIN_LOOP_CONFIG" \
    --num-workers 1 \
    --cpu-per-worker 4 \
    --gpu-per-worker 0 \
    --num-epochs 2 \
    --batch-size 256 \
    --results-fp $RESULTS_FILE

# TODO: Save model to s3
#ENV MODEL_REGISTRY=$(python -c "from madewithml import config; print(config.MODEL_REGISTRY)")
#RUN aws s3 cp $MODEL_REGISTRY s3://madewithml/$GITHUB_USERNAME/mlflow/ --recursive
#RUN aws s3 cp results/ s3://madewithml/$GITHUB_USERNAME/results/ --recursive
