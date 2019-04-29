FROM opendatacube/datacube-core:latest

RUN pip3 install bokeh
RUN pip3 install dask[complete] distributed --upgrade \
    && rm -rf $HOME/.cache/pip

WORKDIR /code/

WORKDIR /code/dask/

ADD health.py /usr/local/bin/dask-scheduler-health.py
ADD adaptive.py /usr/local/bin/dask-scheduler-adaptive.py
