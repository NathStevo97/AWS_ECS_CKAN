FROM python:3.9-slim-bookworm@sha256:a40cf9eba2c3ed9226afa9ace504f07ad30fe831343bb1c69f7a6707aadb7c21

ENV DATAPUSHER_HOME=/usr/lib/ckan/datapusher

# install dependencies
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update \
    && apt-get -y install \
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

# set working directory
WORKDIR $DATAPUSHER_HOME/src

# clone the datapusher repository
# this was 0.0.17, which, is no longer loading certain python modules.
RUN git clone -b '0.0.20' https://github.com/ckan/datapusher.git

WORKDIR $DATAPUSHER_HOME/src/datapusher

RUN python -m pip install --upgrade pip

# install datapusher and its dependencies
COPY ./requirements.txt ./requirements.txt
RUN pip install -r requirements.txt --break-system-packages
RUN pip install -e . --break-system-packages

# entrypoint configuration
COPY ./datapusher-entrypoint.sh /datapusher-entrypoint.sh
COPY ./datapusher_settings.py $DATAPUSHER_HOME/src/datapusher/deployment/datapusher_settings.py.unconfigured
RUN chmod 700 /datapusher-entrypoint.sh

# configure and run the datapusher service
EXPOSE 8800
ENTRYPOINT ["/datapusher-entrypoint.sh"]
CMD [ "python", "datapusher/main.py", "deployment/datapusher_settings.py"]