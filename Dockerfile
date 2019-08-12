FROM opendatacube/datacube-core

RUN apt-get update && apt-get install -y \
    npm \
    nodejs \
    graphviz \
    proj-bin \
    libproj-dev \
    rsync \
# developer convenience
    less \
    wget \
    curl \
    vim \
    tmux \
    htop \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g configurable-http-proxy

RUN pip3 install --upgrade pip \
    && hash -r \
    && rm -rf $HOME/.cache/pip

# Get dependencies for Jupyter
RUN pip3 install \
    tornado \
    jupyter \
    jupyterhub \
    jupyterlab \
    jupyter-server-proxy \
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
    geoviews \
    holoviews \
    cartopy \
    param \
    datashader \
    numexpr \
    cligj  --upgrade \
    && rm -rf $HOME/.cache/pip

RUN jupyter nbextension enable --py --sys-prefix ipyleaflet

RUN echo "Adding jupyter lab extensions" \
&& jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager \
&& jupyter labextension install --no-build @jupyterlab/geojson-extension \
&& jupyter labextension install --no-build jupyter-leaflet \
&& jupyter labextension install --no-build dask-labextension \
&& jupyter labextension install --no-build jupyter-matplotlib \
&& jupyter labextension install --no-build jupyterlab_bokeh \
&& jupyter lab build

RUN echo Installing dea-proto libs \
&& pip3 install --no-cache -U 'aiobotocore[boto3]' \
&& pip3 install --no-cache --extra-index-url="https://packages.dea.gadevs.ga" \
odc_ui \
odc_index \
odc_aws \
odc_geom \
odc_io \
odc_aio \
odc_ppt \
odc_dscache \
odc_dtools \
&& rm -rf $HOME/.cache/pip

RUN mkdir /conf && chmod -R 777 /conf
ENV DATACUBE_CONFIG_PATH=/conf/datacube.conf

RUN chmod -R 777 /opt/odc

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
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
   chmod g+w /etc/passwd /etc/group && \
   fix-permissions $HOME

ENV HOME=/home/jovyan
RUN mkdir -p $HOME && chmod -R 777 $HOME

WORKDIR $HOME
USER jovyan

CMD ["jupyterhub", "--ip=\"*\""]
