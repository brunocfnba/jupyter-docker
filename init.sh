#!/bin/bash

python3 $SPARK_HOME/set_pwd.py $JUPYTER_PWD

ret=$?
if [ $ret -ne 0 ]; then
     exit 1
fi

jupyter notebook --ip=0.0.0.0 --no-browser --allow-root