FROM centos:latest

COPY bin/main.sh /usr/local/

RUN yum -q -y install ruby

CMD ["ruby", "/usr/local/main.sh"]
