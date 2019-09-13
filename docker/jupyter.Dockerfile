FROM opendatacube/datacube-dask

# Copy some components of configuration of Jupyter from https://github.com/jupyter/docker-stacks/
# Configure environment
ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    GDAL_DATA=/usr/share/gdal/2.4/

# Create user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
   && chmod g+w /etc/passwd /etc/group \
   && fix-permissions $HOME

ENV HOME=/home/jovyan \
    SHELL="bash" \
    PATH="$HOME/.local/bin:$PATH"
RUN mkdir -p $HOME && chmod -R 777 $HOME 

EXPOSE 9988

WORKDIR $HOME
USER jovyan

ENTRYPOINT ["/bin/tini", "-s", "--", "docker-entrypoint.sh"]

CMD ["jupyter", "lab", \
"--ip=0.0.0.0", \
"--port=9988", \
"--no-browser"]
