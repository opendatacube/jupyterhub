FROM opendatacube/datacube-core

RUN apt-get update && apt-get install -y \
    npm \
    nodejs \
    graphviz \
    rsync \
    nano \
    nodejs

RUN npm install -g configurable-http-proxy

# Get dependencies for Jupyter
RUN pip3 install \
    tornado \
    jupyter \
    jupyterhub \
    jupyterlab \
    matplotlib \
    folium \
    nbgitpuller \
    geopandas \
    scikit-image \
    fiona \
    ipyleaflet \
    geopy \
    graphviz \
    rasterstats \
    https://github.com/Kirill888/wk-misc/releases/download/v1.0/kk_dtools-1-py3-none-any.whl \
    git+https://github.com/opendatacube/dea-proto.git#egg=odc_aws&subdirectory=libs/aws \
    git+https://github.com/opendatacube/dea-proto.git#egg=odc_aws&subdirectory=libs/dtools \
    git+https://github.com/opendatacube/dea-proto.git#egg=odc_aws&subdirectory=libs/index \
    git+https://github.com/opendatacube/dea-proto.git#egg=odc_aws&subdirectory=libs/io \
    git+https://github.com/opendatacube/dea-proto.git#egg=odc_aws&subdirectory=libs/ppt \
    git+https://github.com/opendatacube/dea-proto.git#egg=odc_aws&subdirectory=libs/ui \
    && rm -rf $HOME/.cache/pip

RUN pip3 install dask[complete] distributed --upgrade

RUN jupyter labextension install \
    @jupyter-widgets/jupyterlab-manager \
    @jupyterlab/geojson-extension \
    @jupyterlab/git \
    dask-labextension \
    jupyter-leaflet \
    jupyter-matplotlib \
    jupyterlab_bokeh \
    nbdime-jupyterla

RUN jupyter nbextension enable --py --sys-prefix ipyleaflet

RUN mkdir /conf && chmod -R 777 /conf
ENV DATACUBE_CONFIG_PATH=/conf/datacube.conf

# Copy some components of configuration of Jupyter from https://github.com/jupyter/docker-stacks/
# Configure environment
ENV NB_USER=jovyan \
   NB_UID=1000 \
   NB_GID=100 \
   GDAL_DATA=/usr/share/gdal/2.4/

ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/fix-permissions /usr/local/bin/fix-permissions
RUN chmod +x /usr/local/bin/fix-permissions
# Create user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/rbash -N -u $NB_UID $NB_USER && \
   chmod g+w /etc/passwd /etc/group && \
   fix-permissions $HOME

ENV HOME=/home/jovyan
RUN mkdir -p $HOME && chmod -R 777 $HOME

RUN mkdir -p /tmp/examples && chmod -R 777 /tmp/examples
ADD odc-sandbox-notebooks /tmp/examples

WORKDIR $HOME
USER jovyan
ENV SHELL=/bin/bash