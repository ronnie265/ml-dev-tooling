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
ENV EXPERIMENT_NAME="llm"
ENV RUN_ID=$(python madewithml/predict.py get-best-run-id --experiment-name $EXPERIMENT_NAME --metric val_loss --mode ASC)

# TODO: Get $RUN_ID from s3
RUN python madewithml/serve.py --run_id $RUN_ID
