FROM ubuntu:latest

COPY bin/main.sh /usr/local/

RUN apt-get update \
    && apt-get install -y ruby

CMD ["ruby", "/usr/local/main.sh"]
