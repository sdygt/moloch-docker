FROM ubuntu:18.04
LABEL maintainer="root@sdygt.net"

ENV MOLOCH_ELASTICSEARCH http://127.0.0.1:9200
ENV MOLOCH_INTERFACE eth0

ADD /scripts /data/

RUN apt-get update && apt-get install -y net-tools wget libwww-perl libjson-perl ethtool libyaml-dev && \
    mkdir /home/tmp && cd /home/tmp && \
    wget "https://files.molo.ch/builds/ubuntu-18.04/moloch_1.5.3-1_amd64.deb" && \
    dpkg -i moloch_1.5.3-1_amd64.deb && \
    apt-get --fix-broken install && \
    rm -f /home/tmp/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /home/tmp
RUN chmod +x /data/moloch-setup.sh /data/run-moloch.sh && /data/moloch-setup.sh
    
VOLUME [ "/data/moloch/raw" ]
VOLUME [ "/data/pcap" ]

EXPOSE 8005/tcp
WORKDIR /data/moloch/viewer/
ENTRYPOINT /data/run-moloch.sh