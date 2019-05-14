FROM opendatacube/datacube-core

RUN apt-get update && apt-get install -y \
    npm \
    nodejs \
    graphviz \
    rsync

RUN npm install -g configurable-http-proxy

RUN pip3 install --upgrade pip \
    && rm -rf $HOME/.cache/pip
    
# Get dependencies for Jupyter
RUN pip3 install \
    tornado==5.1.1 \
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
    dask==1.2.2 \
    distributed \
    graphviz \
    plotly \
    https://github.com/Kirill888/wk-misc/releases/download/v1.0/kk_dtools-1-py3-none-any.whl \
    && rm -rf $HOME/.cache/pip

RUN jupyter nbextension enable --py --sys-prefix ipyleaflet

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
