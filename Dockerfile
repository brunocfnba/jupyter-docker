FROM openjdk:8

ENV SPARK_VERSION="2.4.3"
ENV SPARK_HADOOP_VERSION="2.7"
ENV SPARK_HOME=/home/spark-jupyter/spark
ENV PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
ENV PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH"
ENV PYSPARK_PYTHON=python3
ENV PYTHONPATH=${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip:${SPARK_HOME}/python:${SPARK_HOME}/python/build:$PYTHONPATH

RUN apt-get update \
    && apt install -y python3 python3-setuptools python3-pip python-minimal python-pip \
    wget curl unzip zip vim

ARG PYTHONDEPS="python-dotenv jupyter"
RUN python3 -m pip install ${PYTHONDEPS}

RUN mkdir -p /home/spark-jupyter && cd /home/spark-jupyter && \
    wget http://mirrors.ocf.berkeley.edu/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz

COPY init.sh /opt/init.sh

RUN chmod -R 775 /home/spark-jupyter/* && chmod -R 775 /opt/init.sh && \
    cd /home/spark-jupyter && tar -xvf /home/spark-jupyter/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz && \
    mv /home/spark-jupyter/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION} /home/spark-jupyter/spark && \
    rm /home/spark-jupyter/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz

COPY set_pwd.py ${SPARK_HOME}/set_pwd.py

RUN jupyter notebook --generate-config && \
    chmod -R 775 ${SPARK_HOME}/set_pwd.py && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.45/aws-java-sdk-s3-1.11.45.jar -O ${SPARK_HOME}/jars/aws-java-sdk-s3-1.11.45.jar && \
    wget http://central.maven.org/maven2/com/ibm/stocator/stocator/1.0.25/stocator-1.0.25.jar -O ${SPARK_HOME}/jars/stocator-1.0.25.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.45/aws-java-sdk-1.11.45.jar -O ${SPARK_HOME}/jars/aws-java-sdk-1.11.45.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.415/aws-java-sdk-core-1.11.415.jar -O ${SPARK_HOME}/jars/aws-java-sdk-core-1.11.415.jar && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.7/hadoop-aws-2.7.7.jar -O ${SPARK_HOME}/jars/hadoop-aws-2.7.7.jar

WORKDIR /home/spark-jupyter

ENTRYPOINT ["/opt/init.sh"]