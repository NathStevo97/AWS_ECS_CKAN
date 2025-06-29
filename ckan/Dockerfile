FROM python:3.9-slim-bookworm@sha256:a40cf9eba2c3ed9226afa9ace504f07ad30fe831343bb1c69f7a6707aadb7c21

COPY ./requirements.txt ./requirements.txt

# install dependencies
RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade \
    && apt-get -q -y install \
        python3-wheel \
        libpq-dev \
        libmagic-dev \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        postgresql-client \
        build-essential \
        git-core \
        vim \
        wget \
        gettext-base \
        netcat-traditional \
    && apt-get -y autoremove \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade awscli
RUN pip install --upgrade virtualenv

# ckan install environment
ENV CKAN_HOME=/usr/lib/ckan
ENV CKAN_VENV=$CKAN_HOME/venv
ENV CKAN_CONFIG=/etc/ckan
ENV CKAN_STORAGE_PATH=/var/lib/ckan
ENV CKAN_SRC=$CKAN_VENV/src

# ckan user account
RUN useradd -r -u 900 -m -c "ckan account" -d $CKAN_HOME -s /bin/false ckan

# configure ckan virtual environment
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH \
    && virtualenv $CKAN_VENV \
    && ln -s $CKAN_VENV/bin/pip /usr/local/bin/ckan-pip \
    && ln -s $CKAN_VENV/bin/ckan /usr/local/bin/ckan

# pull the ckan source code
RUN git clone --progress https://github.com/ckan/ckan.git $CKAN_SRC \
    && cd $CKAN_SRC \
    && git checkout tags/ckan-2.11.2 \
    && rm -rf .git .github

# install ckan
RUN ckan-pip install -U pip \
    && ckan-pip install --upgrade --no-cache-dir -r $CKAN_SRC/requirements.txt \
    && ckan-pip install -e $CKAN_SRC/ \
    && ln -s $CKAN_SRC/ckan/config/who.ini $CKAN_CONFIG/who.ini \
    && chown -R ckan:ckan $CKAN_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH

## install pages plugin
RUN ckan-pip install --upgrade --no-cache-dir pylons
RUN ckan-pip install -e 'git+https://github.com/ckan/ckanext-pages.git#egg=ckanext-pages'

# Install custom files
#COPY img/* $CKAN_SRC/ckan/public/base/images/
# COPY overrides/* $CKAN_SRC/tmp/
#RUN mkdir $CKAN_SRC/tmp
#RUN mkdir $CKAN_SRC/tmp/css
#COPY html/* $CKAN_SRC/tmp/
#COPY css/* $CKAN_SRC/tmp/css
#RUN cp $CKAN_SRC/tmp/promoted.html $CKAN_SRC/ckan/templates/home/snippets/promoted.html
#RUN cp $CKAN_SRC/tmp/search.html $CKAN_SRC/ckan/templates/home/snippets/search.html
#RUN cp $CKAN_SRC/tmp/layout4.html $CKAN_SRC/ckan/templates/home/layout4.html
#RUN cp $CKAN_SRC/tmp/index.html $CKAN_SRC/ckan/templates/home/index.html
#RUN cp $CKAN_SRC/tmp/header.html $CKAN_SRC/ckan/templates/header.html
#RUN cp $CKAN_SRC/tmp/page.html $CKAN_SRC/ckan/templates/page.html
#RUN cp $CKAN_SRC/tmp/css/main.css $CKAN_SRC/ckan/public/base/css/main.css

# Copy header override; this can probably be removed when upgrade to python3 happens
# to use the official googleanalytics plugin instead
#RUN cp $CKAN_SRC/tmp/header.html $CKAN_SRC/ckan/templates/header.html
# Add extra helper functions
#RUN cat $CKAN_SRC/tmp/extra-helper-functions.py >> $CKAN_SRC/ckan/lib/helpers.py
# Override robots.txt
#RUN cp $CKAN_SRC/tmp/robots.txt $CKAN_SRC/ckan/public/robots.txt

RUN pip install setuptools==78.1.1

# customize container entrypoint that will configure the application
COPY ckan-entrypoint.sh /ckan-entrypoint.sh
COPY production.ini $CKAN_CONFIG/production.ini.unconfigured
RUN chmod +x /ckan-entrypoint.sh
#RUN cat /ckan-entrypoint.sh | sed '1 s/\r$//' > /ckan-entrypoint.sh
#ENV CKAN_INI=/etc/ckan/production.ini.unconfigured
ENV CKAN_INI=/etc/ckan/production.ini
ENV CKAN_PORT=5000

ENTRYPOINT ["/ckan-entrypoint.sh"]
CMD ["bash", "-c", "ckan run --host 0.0.0.0 --port $CKAN_PORT --threaded"]
