FROM solr:9.8.1-slim@sha256:49f2206d95faa2d88cd67cca56e4c55bee61a2cdc44211495996470f71023037

EXPOSE 8983

ENV SOLR_CONFIG_DIR="/opt/solr/server/solr/configsets"
ENV SOLR_SCHEMA_FILE="$SOLR_CONFIG_DIR/ckan/conf/managed-schema"

USER root

RUN cd /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/ && \
    rm -f netty-handler-*.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-handler/4.1.118.Final/netty-handler-4.1.118.Final.jar

RUN cp -R $SOLR_CONFIG_DIR/_default $SOLR_CONFIG_DIR/ckan

ADD https://raw.githubusercontent.com/ckan/ckan/master/ckan/config/solr/schema.xml $SOLR_SCHEMA_FILE
RUN chmod 644 $SOLR_SCHEMA_FILE

USER solr

CMD ["sh", "-c", "solr-precreate ckan $SOLR_CONFIG_DIR/ckan"]
