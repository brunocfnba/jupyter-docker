#!/bin/bash

python3 $SPARK_HOME/set_pwd.py $JUPYTER_PWD

jupyter notebook --ip=0.0.0.0 --no-browser --allow-root