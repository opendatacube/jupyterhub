FROM opendatacube/datacube-core

RUN apt-get update && apt-get install -y \
    npm \
    nodejs \
    graphviz \
    proj-bin \
    libproj-dev \
    rsync \
    libgsl-dev \
# developer convenience
    less \
    wget \
    curl \
    vim \
    tmux \
    htop \
    fish \
    && rm -rf /var/lib/apt/lists/*

# Install Tini
RUN curl -s -L -O https://github.com/krallin/tini/releases/download/v0.18.0/tini \
&& echo "12d20136605531b09a2c2dac02ccee85e1b874eb322ef6baf7561cd93f93c855 *tini" | sha256sum -c - \
&& install -m 755 tini /bin/tini \
&& rm tini

RUN pip3 install --upgrade pip \
    && hash -r \
    && rm -rf $HOME/.cache/pip

# Get dependencies for Jupyter
RUN pip3 install \
    tornado \
    ipympl \
    jupyter==1.0.0 \
    jupyterlab==1.0.9 \
    jupyter-server-proxy==1.1.0 \
    jupyterhub==1.0.0 \
    ipyleaflet==0.11.1 \
    dask-labextension==1.0.3 \
    nbdime==1.1.0 \
    jupyterlab_code_formatter==0.5.0 \
    black \
    autopep8 \
    yapf \
    isort \
    mypy \
    matplotlib \
    folium \
    nbgitpuller \
    geopandas \
    scikit-image \
    fiona \
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

RUN jupyter nbextension enable --py --sys-prefix ipyleaflet \
&& jupyter serverextension enable --py --sys-prefix jupyterlab_code_formatter \
&& jupyter serverextension list

RUN echo "Adding jupyter lab extensions" \
&& jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager@v1.0.2 \
&& jupyter labextension install --no-build @jupyterlab/geojson-extension@v1.0.0 \
&& jupyter labextension install --no-build @jupyterlab/hub-extension@v1.1.0 \
&& jupyter labextension install --no-build jupyter-leaflet@v0.11.1 \
&& jupyter labextension install --no-build dask-labextension@v1.0.1 \
&& jupyter labextension install --no-build jupyter-matplotlib@v0.4.2 \
&& jupyter labextension install --no-build jupyterlab_bokeh@v1.0.0 \
&& jupyter labextension install --no-build nbdime-jupyterlab@v1.0.0 \
&& jupyter labextension install --no-build @ryantam626/jupyterlab_code_formatter@v0.5.0 \
&& jupyter lab build \
&& jupyter labextension list \
&& echo "...done"

RUN echo "Installing more libs" \
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
otps \
&& config_otps \
&& rm -rf $HOME/.cache/pip

RUN mkdir /conf && chmod -R 777 /conf
ENV DATACUBE_CONFIG_PATH=/conf/datacube.conf

RUN chmod -R 777 /opt/odc

ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/fix-permissions /usr/local/bin/fix-permissions
RUN chmod +x /usr/local/bin/fix-permissions

COPY adaptive.py /usr/local/bin/dask-scheduler-adaptive.py
COPY health.py /usr/local/bin/dask-scheduler-health.py
COPY kubernetes.yaml /etc/config/datacube/kubernetes-dask-default.yaml

WORKDIR /code/dask
