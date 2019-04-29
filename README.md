# Jupyter notebook on Docker for Spark
Simple code to run Spark code accessing IBM Object Store or S3 on Jupyter notebook.

### Setup Instructions
1. Download and install docker on [docker.com](https://www.docker.com/get-started).
2. Clone this repo.
3. Create the docker imagine running the following command from the same directory as your Dockerfile
```
docker build -t jupyter-docker .
```
4. Start your docker container running `docker run -d --name jupyter -p 8888:8888 -e JUPYTER_PWD=<your jupyter password> jupyter-docker`
> Make sure to expose the ports to run locally and to define a password to access the UI.<BR>
> Password must have at least 8 characters
  
5. Go to your browser and access `localhost:8888` then type the password you created.
