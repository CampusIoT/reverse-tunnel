FROM       ubuntu:16.04
MAINTAINER CampusIoT Dev Team "https://github.com/campusiot"

RUN apt-get update

RUN apt-get install -y openssh-server sshpass
RUN mkdir /var/run/sshd

#RUN echo 'root:SUPER_SECRET_TO_CHANGE' | chpasswd
#RUN mkdir /root/.ssh

RUN sed -ri 's/Port 22/Port 2222/g' /etc/ssh/sshd_config
RUN sed -ri 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
#RUN sed -ri 's/#Banner none/Banner none/g' /etc/ssh/sshd_config

ADD press_to_exit.sh /bin/
RUN chmod +x /bin/press_to_exit.sh


RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /root/sshkeys
ADD sshkeys/*.pub /root/sshkeys/
ADD create_gateways_accounts.sh /root/create_gateways_accounts.sh
RUN /bin/bash /root/create_gateways_accounts.sh

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D"]
