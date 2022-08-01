# Local testing

Build Docker image and tag:
```
docker build . -t kose/jsm2022-julia-short-course
```

Push docker image tag to Docker Hub:
```
docker push kose/jsm2022-julia-short-course
```
Note that docker image is pulled on `helm upgrade`. Using `latest` may have some delay, so one needs to use more explicit tag or commit for the tag field of `config.yaml`.


Run a container on local machine:
```
docker-compose up
```
Make sure to modify the volume line in `docker-compose.yml` to the correct path to the local mimic data file folder. Point browser to the URL (with token) displayed on terminal, e.g., `http://127.0.0.1:8888/lab?token=1e2ac1bebc02b17b74833a36435499fc47a40c81c2d80548` for the JupyterLab interface. <!--Open a terminal within JupyterLab and `git clone https://github.com/LangeSymposium/2022-July-Workshop.git`.-->

