#!/bin/bash -e

export PYTHONPATH=$PYTHONPATH:$PWD
pip install --quiet 'poetry==1.2.0'
poetry run pip install --quiet --upgrade pip
poetry install
