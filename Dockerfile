FROM ubuntu:latest
RUN apt-get update
RUN apt-get -y install openssh-server supervisor unzip openjdk-8-jdk
RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config-master && \
    mkdir /run/sshd
ADD resources/supervisord.conf /etc/supervisord.conf
ADD resources/sshd_config /etc/ssh/sshd_config
ADD resources/start.sh /start.sh
RUN chmod +x /start.sh
RUN ssh-keygen -A && echo "root:xebialabs" | chpasswd

RUN cd /opt/ && \
    wget http://download.oracle.com/glassfish/5.0/release/glassfish-5.0.zip && \
    unzip glassfish-5.0.zip && \
    rm -f glassfish-5.0.zip && \
    ln -s /opt/glassfish5 /opt/glassfish


EXPOSE 22 8080 8181 4848
VOLUME ["/opt/glassfish/glassfish/domains"]
CMD ["/usr/bin/supervisord"]
