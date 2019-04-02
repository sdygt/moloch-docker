FROM ubuntu:18.04
LABEL maintainer="root@sdygt.net"

ENV MOLOCH_ELASTICSEARCH http://127.0.0.1:9200
ENV MOLOCH_INTERFACE eth0

RUN apt-get update && apt-get install -y net-tools wget curl libwww-perl libjson-perl ethtool libyaml-dev libmagic-dev && \
    mkdir /home/tmp && cd /home/tmp && \
    wget "https://files.molo.ch/builds/ubuntu-18.04/moloch_1.7.1-1_amd64.deb" && \
    dpkg -i moloch_1.7.1-1_amd64.deb && \
    apt-get --fix-broken install && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /home/tmp

ADD /scripts /data/
RUN chmod +x /data/*.sh && /data/moloch-setup.sh
    
VOLUME [ "/data/moloch/raw" ]
VOLUME [ "/data/pcap" ]

EXPOSE 8005/tcp
WORKDIR /data/moloch/viewer/
CMD [ "/data/run-moloch.sh" ] 
