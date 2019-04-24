FROM ubuntu

#RUN cp /bin/bash /bin/rbash
RUN useradd -s /bin/rbash jovyan

RUN mkdir /home/jovyan/programs

ADD .bash_profile /home/jovyan/.bash_profile

USER jovyan