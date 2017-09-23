FROM alpine:edge


ARG BRANCH=abcd
ARG WORK=~
ARG URL1=https://raw.githubusercontent.com/aiastia/mudbjsonss/master/mudb.json
ARG URL2=https://raw.githubusercontent.com/aiastia/mudbjsonss/master/userapiconfig.py

RUN set -ex && \
    apk add --no-cache udns && \
    apk add --no-cache --virtual .build-deps \
                                git \
                                autoconf \
                                automake \
                                make \
                                build-base \
                                curl \
                                wget \
                                libev-dev \
                                c-ares-dev \
                                libtool \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                udns-dev && \

    cd /tmp/ && \
    git clone  -b abcd https://github.com/shadowsocksR-private/shadowsocksR.git && \
    cd shadowsocksR && \
    chmod +x *.sh && \
    chmod +x shadowsocks/*.sh && \
    cp apiconfig.py userapiconfig.py && \
    wget -qO 1.json --no-check-certificate $URL1  && \    
    cp 1.json mudb.json && \
    wget -qO 2.py --no-check-certificate $URL2 && \
    cp 2.py userapiconfig.py 
    
 RUN cd /tmp/ && \
     cd shadowsocksR && \
    rm -rf shadowsocks


ENV SERVER_ADDR 0.0.0.0
ENV METHOD chacha20
ENV TIMEOUT 300
ENV DNS_ADDR 8.8.8.8
ENV DNS_ADDR_2 8.8.4.4

WORKDIR /tmp/shadowsocksR

ENTRYPOINT ["bash","./tmp/shadowsocksR/logrun.sh &"]



