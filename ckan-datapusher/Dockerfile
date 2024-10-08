FROM --platform=linux/amd64 ubuntu:24.04

ENV DATAPUSHER_HOME=/usr/lib/ckan/datapusher

# install dependencies
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update \
    && apt-get -y install \
        python3-dev \
        python3-pip \
        build-essential \
        libxslt1-dev \
        libxml2-dev \
        zlib1g-dev \
        git \
        gettext-base \
        locales-all \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && python --version
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && pip --version

# create home directory of datapusher
RUN mkdir -p $DATAPUSHER_HOME/src

# set working directory
WORKDIR $DATAPUSHER_HOME/src

# clone the datapusher repository
# this was 0.0.17, which, is no longer loading certain python modules.
RUN git clone -b '0.0.20' https://github.com/ckan/datapusher.git

# install datapusher and it's dependencies
WORKDIR $DATAPUSHER_HOME/src/datapusher
COPY ./requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt --break-system-packages && pip install -e . --break-system-packages
RUN pip3 install werkzeug==3.0.3 --break-system-packages

# entrypoint configuration
COPY ./datapusher-entrypoint.sh /datapusher-entrypoint.sh
COPY ./datapusher_settings.py $DATAPUSHER_HOME/src/datapusher/deployment/datapusher_settings.py.unconfigured
RUN chmod 700 /datapusher-entrypoint.sh

# configure and run the datapusher service
EXPOSE 8800
ENTRYPOINT ["/datapusher-entrypoint.sh"]
CMD [ "python", "datapusher/main.py", "deployment/datapusher_settings.py"]
