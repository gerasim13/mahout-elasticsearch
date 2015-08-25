FROM yvess/alpine-elasticsearch
MAINTAINER Pavel Litvinenko <gerasim13@gmail.com>

ENV MAHOUT 0.11.0
ADD http://apache-mirror.rbc.ru/pub/apache/mahout/${MAHOUT}/apache-mahout-distribution-${MAHOUT}.tar.gz /tmp/${MAHOUT}.tar.gz

ENV MAVEN 3.3.1
ADD http://ftp.fau.de/apache/maven/maven-3/${MAVEN}/binaries/apache-maven-${MAVEN}-bin.tar.gz /tmp/${MAVEN}.tar.gz

RUN apk update && apk add tar && \
    mkdir /tmp/${MAHOUT} && \
    mkdir /tmp/${MAVEN} && \
    tar -xzvf /tmp/${MAHOUT}.tar.gz -C /tmp/${MAHOUT} && \
    tar -xzvf /tmp/${MAVEN}.tar.gz -C /tmp/${MAVEN} && \
    cp -r /tmp/${MAHOUT}/* /usr/lib/mahout && \
    mv /tmp/${MAVEN}/* /usr/lib/mvn && \
    rm -rf /tmp/* /var/cache/apk/*

ENV MAHOUT_LOCAL true
ENV MAHOUT_HOME /usr/lib/mahout
ENV MAHOUT_BIN $MAHOUT_HOME/bin
ENV MAVEN_HOME /usr/lib/mvn
ENV MAVEN_BIN $MAVEN_HOME/bin
ENV ES_HOME /elasticsearch
ENV ES_BIN $ES_HOME/bin
ENV PATH $PATH:$MAVEN_HOME:$MAVEN_BIN:$MAHOUT_HOME:$MAHOUT_BIN:$ES_HOME:$ES_BIN

# Install plugins
RUN plugin -install lmenezes/elasticsearch-kopf/v1.5.7 && \
    plugin -install royrusso/elasticsearch-HQ && \
    plugin -install elasticsearch/elasticsearch-lang-python/2.7.0 && \
    plugin -install org.codelibs/elasticsearch-taste/1.5.0 && \
    plugin -install flavor -url 'https://github.com/f-kubotar/elasticsearch-flavor/releases/download/v0.0.3/elasticsearch-flavor-0.0.3.zip' && \
    plugin -install entity-resolution -url 'https://bintray.com/artifact/download/yann-barraud/elasticsearch-entity-resolution/org/yaba/elasticsearch-entity-resolution-plugin/1.4.0.0/elasticsearch-entity-resolution-plugin-1.4.0.0.zip' && \
    plugin -install view-plugin -url 'https://oss.sonatype.org/content/repositories/releases/com/github/tlrx/elasticsearch-view-plugin/0.0.2/elasticsearch-view-plugin-0.0.2-zip.zip' && \
    echo -ne "- with Elasticsearch `elasticsearch -v`\n" >> /root/.built && \
    rm -rf /tmp/*
