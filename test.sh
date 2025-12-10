#!/bin/bash
export PYTHONPATH=$PYTHONPATH:$(pwd)/app
pytest app/tests
