FROM openjdk:11

ENV SPARK_VERSION="3.4.1"
ENV SPARK_HADOOP_VERSION="3"
ENV SPARK_HOME=/home/spark-jupyter/spark
ENV PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
ENV PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"
ENV PYSPARK_PYTHON=python3
ENV PYTHONPATH=${SPARK_HOME}/python/build:$PYTHONPATH

RUN apt-get update \
    && apt install -y python python3-pip \
    wget curl unzip zip vim

ARG PYTHONDEPS="python-dotenv jupyterlab==3.4.2 notebook==6.4.12"
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install ${PYTHONDEPS}

RUN mkdir -p /home/spark-jupyter && cd /home/spark-jupyter && \
    wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz

COPY init.sh /opt/init.sh

RUN chmod -R 775 /home/spark-jupyter/* && chmod -R 775 /opt/init.sh && \
    cd /home/spark-jupyter && tar -xvf /home/spark-jupyter/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz && \
    mv /home/spark-jupyter/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION} /home/spark-jupyter/spark && \
    rm /home/spark-jupyter/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz

COPY set_pwd.py ${SPARK_HOME}/set_pwd.py

RUN jupyter lab --generate-config && \
    chmod -R 775 ${SPARK_HOME}/set_pwd.py && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.12.230/aws-java-sdk-s3-1.12.230.jar -O ${SPARK_HOME}/jars/aws-java-sdk-s3-1.12.230.jar && \
    wget https://repo1.maven.org/maven2/com/ibm/stocator/stocator/1.1.4/stocator-1.1.4.jar -O ${SPARK_HOME}/jars/stocator-1.1.4.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.12.230/aws-java-sdk-core-1.12.230.jar -O ${SPARK_HOME}/jars/aws-java-sdk-core-1.12.230.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.3/hadoop-aws-3.3.3.jar -O ${SPARK_HOME}/jars/hadoop-aws-3.3.3.jar

WORKDIR /home/spark-jupyter

ENTRYPOINT ["/opt/init.sh"]
