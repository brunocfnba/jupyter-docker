#!/bin/bash

if grep -Rq "c.NotebookApp.password = u" "/root/.jupyter/jupyter_notebook_config.py"
then
    echo "No updates required"
else
    echo "Setting password"
    python3 $SPARK_HOME/set_pwd.py $JUPYTER_PWD
fi

ret=$?
if [ $ret -ne 0 ]; then
     exit 1
fi

unset $JUPYTER_PWD

jupyter lab --ip=0.0.0.0 --no-browser --allow-root