FROM alpine

RUN apk --update add curl linux-headers gcc make musl-dev patch && \
    wget https://github.com/fujita/tgt/archive/refs/tags/v1.0.88.tar.gz && \
    mkdir tgt/ && tar xvzf v1.0.88.tar.gz && rm v1.0.88.tar.gz && \
    cd tgt-1.0.88 && \
    curl -fsSL https://github.com/void-linux/void-packages/raw/master/srcpkgs/tgt/patches/musl-__wordsize.patch | patch -p1 && \
    make -j$(nproc) && \
    mv usr/tgtd /usr/bin/ && mv usr/tgtadm /usr/bin/ && mv usr/tgtimg /usr/bin/ && \
    rm -rf /tgt && apk del curl linux-headers gcc make musl-dev patch

COPY entrypoint.sh /

ENV DISK_SIZE=10240 \
    IQN=iqn.2000-01.com.docker:iscsi.disk1 \
    DISK_NAME=disk.img \
    ADDRESS=192.168.1.0/24

EXPOSE 3260/tcp
VOLUME /pool

CMD ["/entrypoint.sh"]

    
