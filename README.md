**This repository is no longer maintained. The DEA Sandbox docker image is now maintained through the [GeoscienceAustralia/dea-sandbox](https://github.com/GeoscienceAustralia/dea-sandbox/) repository.**

# JupyterHub

**Warning: this image needs updating to be compatible with the latest ODC code and our `geobase` image methods**

JupyterHub Docker Image that supports OpenDataCube

## build

```
cd docker && docker build -t opendatacube/jupyterhub .
```

## run

For local testing:

```
docker run --rm -p 9999:9999  \
-e DB_HOSTNAME=db-host.tld \
-e DB_PORT=5432 \
-e DB_DATABASE=datacube \
-e DB_USERNAME=datacube \
-e DB_PASSWORD="some-pass-word" \
opendatacube/jupyterhub:latest \
jupyter lab --no-browser --ip=0.0.0.0 --port 9999
```
