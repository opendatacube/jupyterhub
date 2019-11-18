FROM opendatacube/datacube-core

RUN apt-get update && apt-get install -y \
    npm \
    nodejs \
    graphviz \
    proj-bin \
    libproj-dev \
    rsync \
    ffmpeg \
# developer convenience
    less \
    wget \
    curl \
    vim \
    tmux \
    htop \
    sudo \
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
    seaborn \
    folium \
    nbgitpuller \
    geopandas \
    scikit-image \
    scikit-learn \
    fiona \
    geopy \
    graphviz \
    plotly \
    descartes \
    rasterstats \
    geoviews \
    holoviews \
    cartopy \
    param \
    datashader \
    numexpr \
    numexpr3 \
    jupyter-ui-poll \
    sidecar==0.3.0 \
    ipyevents==0.7.0 \
    ipycanvas==0.3.4 \
    line_profiler \
    tensorflow \
    tensorflow-gpu \
    cligj  --upgrade \
    && rm -rf $HOME/.cache/pip

RUN jupyter nbextension enable --py --sys-prefix ipyleaflet \
&& jupyter serverextension enable --py --sys-prefix jupyterlab_code_formatter \
&& jupyter serverextension list

RUN echo "Adding jupyter lab extensions" \
&& jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager@v1.0.2 \
&& jupyter labextension install --no-build @jupyterlab/geojson-extension@v1.0.0 \
&& jupyter labextension install --no-build @jupyterlab/hub-extension@v1.1.0 \
&& jupyter labextension install --no-build @jupyterlab/plotly-extension@1.0.0 \
&& jupyter labextension install --no-build jupyter-leaflet@v0.11.1 \
&& jupyter labextension install --no-build dask-labextension@v1.0.1 \
&& jupyter labextension install --no-build jupyter-matplotlib@v0.4.2 \
&& jupyter labextension install --no-build jupyterlab_bokeh@v1.0.0 \
&& jupyter labextension install --no-build nbdime-jupyterlab@v1.0.0 \
&& jupyter labextension install --no-build @ryantam626/jupyterlab_code_formatter@v0.5.0 \
&& jupyter labextension install --no-build @jupyter-widgets/jupyterlab-sidecar@v0.4.0 \
&& jupyter labextension install --no-build ipyevents@v1.7.0 \
&& jupyter labextension install --no-build ipycanvas@v0.3.4 \
&& jupyter lab build \
&& jupyter labextension list \
&& echo "...done"

RUN echo Installing more libs \
&& pip3 install --no-cache --extra-index-url="https://packages.dea.ga.gov.au" \
datacube_stats \
odc_ui \
odc_index \
odc_aws \
odc_geom \
odc_io \
odc_aio \
odc_ppt \
odc_dscache \
odc_dtools \
odc_algo \
hdstats \
otps \
&& config_otps \
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
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
   && chmod g+w /etc/passwd /etc/group \
   && fix-permissions $HOME

ENV HOME=/home/${NB_USER}
ENV SHELL="bash"
ENV PATH="$HOME/.local/bin:$PATH"
RUN mkdir -p $HOME && chmod -R 777 $HOME

EXPOSE 9988
WORKDIR $HOME

# when `--build-arg WITH_SUDO=yes` is passed during docker build
#  - add ${nb_user} to sudo group
#  - Allow members of sudo group to run sudo without password
#
# NOTE: arg position within Dockerfile is important, don't move it up, having it
# lower in the file ensures that sudo and non-sudo images share common base.
# Also can't move it lower than USER directive.
ARG WITH_SUDO=no

RUN [ "${WITH_SUDO}" != "yes" ] || { adduser ${NB_USER} sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo 'Enabled sudo access'; }

USER ${NB_USER}

ENTRYPOINT ["/bin/tini", "-s", "--", "docker-entrypoint.sh"]

CMD ["jupyter", "lab", \
"--ip=0.0.0.0", \
"--port=9988", \
"--no-browser"]
