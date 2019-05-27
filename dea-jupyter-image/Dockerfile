FROM opendatacube/datacube-core

RUN apt-get update && apt-get install -y \
    npm \
    nodejs \
    graphviz \
    rsync

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
    numexpr \
    cligj  --upgrade \
    && rm -rf $HOME/.cache/pip

RUN pip3 install dask[complete] distributed --upgrade

RUN jupyter nbextension enable --py --sys-prefix ipyleaflet
RUN jupyter labextension install @jupyterlab/geojson-extension
RUN mkdir /conf && chmod -R 777 /conf
ENV DATACUBE_CONFIG_PATH=/conf/datacube.conf

RUN chmod -R 777 /opt/odc
RUN chown -R 1000:100 /usr/local/share/jupyter/
RUN chown -R 1000:100 /usr/local/lib/python3.6/dist-packages/

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

USER root
RUN jupyter labextension install @jupyterlab/geojson-extension
RUN mkdir -p /tmp/code
ADD start-notebook-with-efs.sh /tmp/code/start-notebook-with-efs.sh
RUN mv /tmp/code/start-notebook-with-efs.sh /usr/local/bin/start-notebook-with-efs.sh
RUN chmod 777 /usr/local/bin/start-notebook-with-efs.sh
CMD ["start-notebook-with-efs.sh"]
# Switch back to jovyan to avoid accidental container runs as root

ENV HOME=/home/jovyan
RUN mkdir -p $HOME && chmod -R 777 $HOME

WORKDIR $HOME
RUN chown -R 1000:100 /usr/local/share/jupyter/
RUN chown -R 1000:100 /usr/local/lib/python3.6/dist-packages/
USER jovyan