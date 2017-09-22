FROM alpine:3.6

ENV SERVER_ADDR     0.0.0.0
ENV SERVER_PORT     51348
ENV PASSWORD        psw
ENV METHOD          aes-128-ctr
ENV PROTOCOL        auth_aes128_md5
ENV PROTOCOLPARAM   32
ENV OBFS            tls1.2_ticket_auth_compatible
ENV TIMEOUT         300
ENV DNS_ADDR        8.8.8.8
ENV DNS_ADDR_2      8.8.4.4



ARG BRANCH=abcd
ARG WORK=~
ARG URL1=https://raw.githubusercontent.com/aiastia/mudbjsonss/master/mudb.json
ARG URL2=https://raw.githubusercontent.com/aiastia/mudbjsonss/master/userapiconfig.py



RUN apk --no-cache add python \
    libsodium \
    wget \
    bash




RUN mkdir -p $WORK && \
    wget --no-check-certificate https://github.com/shadowsocksR-private/shadowsocksR/archive/$BRANCH.tar.gz && \
    ls && \
    tar xzvf $BRANCH.tar.gz -C $WORK && \
    #cd /$WORK/shadowsocksR-$BRANCH && \
    chmod +x $WORK/shadowsocksR-$BRANCH/*.sh 
    #cp apiconfig.py userapiconfig.py && \
    #cp config.json user-config.json && \
    #cp mysql.json usermysql.json



WORKDIR $WORK/shadowsocksR-$BRANCH

RUN wget -O mudb.json -qO- --no-check-certificate $URL1  && \
    cp mudb.json ~/$WORK/shadowsocksR-$BRANCH/mudb.json && \
    wget -O mudb.json -qO- --no-check-certificate $URL2 && \
    cp userapiconfig.py ~/$WORK/shadowsocksR-$BRANCH/userapiconfig.py 





 #RUN yes|cp /tmp/ssr/mudb.json /$WORK/shadowsocksR/


EXPOSE $SERVER_PORT

CMD ./~/shadowsocksR-$BRANCH/run.sh
