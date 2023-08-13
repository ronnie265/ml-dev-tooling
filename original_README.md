# Kaiko Dev Tooling Assignment

## Credits

This assignment is inspired by below sources:
- Lessons: https://madewithml.com/
- Code: [GokuMohandas/Made-With-ML](https://github.com/GokuMohandas/Made-With-ML)

We appreciate and thank the efforts of creators and contributors for sharing their work.

## Background

This assignment is a part of the interview process for the role of Dev Tooling Engineer at Kaiko. The goal of this assignment is to provide a hands-on experience of the work that we do at Kaiko.

These tasks are designed to **not take more than a few hours**. If it takes
longer, please feel free to add notes about your thoughts on the implementation
and we can have further discussion during follow-up meeting.

## Assignment tasks
The assignment is divided into two parts:

- **Part 1**: [ML Engineering](#ml-engineering)

  > The setup and execution of the ML workloads is already implemented. You can find the steps for execution in the [Execution modes](#execution-modes) section. The steps described are for running the workloads on a local machine.

  #### ML Ops Tasks:

    - **Collect Logs and Results:**

      Execute the ML workloads as described on local machine and share below files/folders:
        ```bash
        logs/
        results/
        htmlcov/
        ```

    - **Gihub Action Test Workflow:**

      Implement a Github Action workflow to run the tests on every PR and push to the main branch. The workflow should run the tests and generate the coverage report. The coverage report should be uploaded as an artifact to the workflow run. The workflow should be triggered on every PR and push to the main branch.


- **Part 2**: [Dev Tooling](#dev-tooling)

  In this part, we would take the ML workloads from Part 1 and implement required tooling and best practices which would help engineering teams at Kaiko deploy these applications to Production.

  #### Dev Tooling Tasks:
    - **CI/CD:** Implement CI/CD for the ML workloads using Github Actions. The CI/CD should include the following steps:
      - **Linting:** Run linting on the codebase.
      - **Testing:** Run the tests and generate the coverage report.
      - **Artifact:** Create and publish below artifacts:
        - **Docker:** Build and Publish the docker images for [training](./madewithml/) and [serving](madewithml/serve.py)
        - **Models:** Bundle and upload the models as versioned artifacts to Github

          > You can find sample code under [deploy/jobs/workloads.sh](deploy/jobs/workloads.sh)

    - **Local Dev Cluster:**

      Implement a local dev cluster. The cluster should be able to run the ML workloads and should be able to access the MLflow and Ray dashboards. Provide code and steps to setup the cluster and deploy/run the workloads on this local cluster.

      > Example tooling to setup local dev clusters [ctptl](https://github.com/tilt-dev/ctlptl#what-is-ctlptl), [kind](https://kind.sigs.k8s.io/), [Docker Desktop](https://github.com/tilt-dev/ctlptl#docker-for-mac-enable-kubernetes-and-set-4-cpu), [k3d](https://github.com/tilt-dev/ctlptl#k3d-with-a-built-in-registry-at-a-pre-determined-port), [minikube](https://github.com/tilt-dev/ctlptl#minikube-with-a-built-in-registry-at-kubernetes-v1188),

    - **Pants Build System (Bonus):**

      Adopt the [pants](https://www.pantsbuild.org/) build system for build and test steps in CI/CD. Provide code and steps to setup the build system and run the CI/CD using pants.

      > Reference [guide](https://semaphoreci.com/blog/building-python-projects-with-pants) and [sample code](https://github.com/semaphoreci-demos/semaphore-demo-python-pants/tree/final) to help you get started.


## Evaluation Criteria:

Below are few criteria which we would refer to during evaluation of the submission

- Completeness
- Correctness
- Best practices: Either usage of best practices or summary description of what
  the best practice would be if time does not allow implementing it. (highly
  subjective and hence would guide our follow-up discussions)
- Extensibility
- Ease of use
- Documentation

## Solution Deliverables:

Package the complete folder as a zip file and attach it to the assignment email.

> In case of any difficulties or questions feel free to reach out to us.

**Good luck and hope you enjoy the assignment !!**


## ML Engineering
## Cluster Setup

We'll start by setting up our cluster with the environment and compute configurations.

  Your personal laptop (single machine) will act as the cluster, where one CPU will be the head node and some of the remaining CPU will be the worker nodes. All of the code in this course will work in any personal laptop though it will be slower than executing the same workloads on a larger cluster.

#### K8s (Alternative)

  - On [Kubernetes](https://docs.ray.io/en/latest/cluster/kubernetes/index.html#kuberay-index), via the officially supported KubeRay project.

### Python Virtual environment

  ```bash
  export PYTHONPATH=$PYTHONPATH:$PWD
  python3 -m venv venv  # recommend using Python 3.10
  source venv/bin/activate  # on Windows: venv\Scripts\activate
  python3 -m pip install --upgrade pip setuptools wheel
  python3 -m pip install -r requirements.txt
  pre-commit install
  pre-commit autoupdate
  ```

  > Highly recommend using Python `3.10` and using [pyenv](https://github.com/pyenv/pyenv) (mac) or [pyenv-win](https://github.com/pyenv-win/pyenv-win) (windows).


## Execution modes
### Notebook (Optional)

Start by exploring the [jupyter notebook](notebooks/madewithml.ipynb) to interactively walkthrough the core machine learning workloads.

<div align="center">
  <img src="https://madewithml.com/static/images/mlops/systems-design/workloads.png">
</div>

  ```bash
  # Start notebook
  jupyter lab notebooks/madewithml.ipynb
```

### Scripts (Recommended)

Now we'll execute the same workloads using the clean Python scripts following software engineering best practices (testing, documentation, logging, serving, versioning, etc.) The code we've implemented in our notebook will be refactored into the following scripts:

```bash
madewithml
├── config.py
├── data.py
├── evaluate.py
├── models.py
├── predict.py
├── serve.py
├── train.py
├── tune.py
└── utils.py
```

**Note**: Change the `--num-workers`, `--cpu-per-worker`, and `--gpu-per-worker` input argument values below based on your system's resources. For example, if you're on a local laptop, a reasonable configuration would be `--num-workers 6 --cpu-per-worker 1 --gpu-per-worker 0`.

## Stages

### Training
```bash
export EXPERIMENT_NAME="llm"
export DATASET_LOC="https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/dataset.csv"
export TRAIN_LOOP_CONFIG='{"dropout_p": 0.5, "lr": 1e-4, "lr_factor": 0.8, "lr_patience": 3}'
python madewithml/train.py \
    --experiment-name "$EXPERIMENT_NAME" \
    --dataset-loc "$DATASET_LOC" \
    --train-loop-config "$TRAIN_LOOP_CONFIG" \
    --num-workers 1 \
    --cpu-per-worker 3 \
    --gpu-per-worker 1 \
    --num-epochs 10 \
    --batch-size 256 \
    --results-fp results/training_results.json
```

### Experiment tracking

We'll use [MLflow](https://mlflow.org/) to track our experiments and store our models and the [MLflow Tracking UI](https://www.mlflow.org/docs/latest/tracking.html#tracking-ui) to view our experiments. We have been saving our experiments to a local directory but note that in an actual production setting, we would have a central location to store all of our experiments. It's easy/inexpensive to spin up your own MLflow server for all of your team members to track their experiments on or use a managed solution like [Weights & Biases](https://wandb.ai/site), [Comet](https://www.comet.ml/), etc.

```bash
export MODEL_REGISTRY=$(python -c "from madewithml import config; print(config.MODEL_REGISTRY)")
mlflow server -h 0.0.0.0 -p 8080 --backend-store-uri $MODEL_REGISTRY
```

#### Dashboards

- MLFlow:  If you're running this notebook/scripts on your local laptop then head on over to <a href="http://localhost:8080/" target="_blank">http://localhost:8080/</a> to view your MLflow dashboard.
- Ray:  If you're running this notebook/scripts on your local laptop then head on over to <a href="http://localhost:8265/" target="_blank">http://localhost:8265/</a> to view your Ray dashboard.

### Tuning
```bash
export EXPERIMENT_NAME="llm"
export DATASET_LOC="https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/dataset.csv"
export TRAIN_LOOP_CONFIG='{"dropout_p": 0.5, "lr": 1e-4, "lr_factor": 0.8, "lr_patience": 3}'
export INITIAL_PARAMS="[{\"train_loop_config\": $TRAIN_LOOP_CONFIG}]"
python madewithml/tune.py \
    --experiment-name "$EXPERIMENT_NAME" \
    --dataset-loc "$DATASET_LOC" \
    --initial-params "$INITIAL_PARAMS" \
    --num-runs 2 \
    --num-workers 1 \
    --cpu-per-worker 3 \
    --gpu-per-worker 1 \
    --num-epochs 10 \
    --batch-size 256 \
    --results-fp results/tuning_results.json
```

### Evaluation
```bash
export EXPERIMENT_NAME="llm"
export RUN_ID=$(python madewithml/predict.py get-best-run-id --experiment-name $EXPERIMENT_NAME --metric val_loss --mode ASC)
export HOLDOUT_LOC="https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/holdout.csv"
python madewithml/evaluate.py \
    --run-id $RUN_ID \
    --dataset-loc $HOLDOUT_LOC \
    --results-fp results/evaluation_results.json
```
```json
{
  "timestamp": "June 09, 2023 09:26:18 AM",
  "run_id": "6149e3fec8d24f1492d4a4cabd5c06f6",
  "overall": {
    "precision": 0.9076136428670714,
    "recall": 0.9057591623036649,
    "f1": 0.9046792827719773,
    "num_samples": 191.0
  },
...
```

### Testing
```bash
# Code
python3 -m pytest tests/code --verbose --disable-warnings

# Data
export DATASET_LOC="https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/dataset.csv"
pytest --dataset-loc=$DATASET_LOC tests/data --verbose --disable-warnings

# Model
export EXPERIMENT_NAME="llm"
export RUN_ID=$(python madewithml/predict.py get-best-run-id --experiment-name $EXPERIMENT_NAME --metric val_loss --mode ASC)
pytest --run-id=$RUN_ID tests/model --verbose --disable-warnings

# Coverage
python3 -m pytest --cov madewithml --cov-report html
```

### Inference
```bash
# Get run ID
export EXPERIMENT_NAME="llm"
export RUN_ID=$(python madewithml/predict.py get-best-run-id --experiment-name $EXPERIMENT_NAME --metric val_loss --mode ASC)
python madewithml/predict.py predict \
    --run-id $RUN_ID \
    --title "Transfer learning with transformers" \
    --description "Using transformers for transfer learning on text classification tasks."
```
```json
[{
  "prediction": [
    "natural-language-processing"
  ],
  "probabilities": {
    "computer-vision": 0.0009767753,
    "mlops": 0.0008223939,
    "natural-language-processing": 0.99762577,
    "other": 0.000575123
  }
}]
```

### Serving

  ```bash
  # Start
  ray start --head
  ```

  ```bash
  # Set up
  export EXPERIMENT_NAME="llm"
  export RUN_ID=$(python madewithml/predict.py get-best-run-id --experiment-name $EXPERIMENT_NAME --metric val_loss --mode ASC)
  python madewithml/serve.py --run_id $RUN_ID
  ```

  While the application is running, we can use it via cURL, Python, etc.:

  ```bash
  # via cURL
  curl -X POST -H "Content-Type: application/json" -d '{
    "title": "Transfer learning with transformers",
    "description": "Using transformers for transfer learning on text classification tasks."
  }' http://127.0.0.1:8000/predict
  ```

  ```python
  # via Python
  import json
  import requests
  title = "Transfer learning with transformers"
  description = "Using transformers for transfer learning on text classification tasks."
  json_data = json.dumps({"title": title, "description": description})
  requests.post("http://127.0.0.1:8000/predict", data=json_data).json()
  ```

  ```bash
  ray stop  # shutdown
  ```

```bash
export HOLDOUT_LOC="https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/holdout.csv"
curl -X POST -H "Content-Type: application/json" -d '{
    "dataset_loc": "https://raw.githubusercontent.com/GokuMohandas/Made-With-ML/main/datasets/holdout.csv"
  }' http://127.0.0.1:8000/evaluate
```
