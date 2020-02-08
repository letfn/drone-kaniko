FROM ubuntu:bionic

WORKDIR /drone/src

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y figlet rsync curl make git

RUN curl -sSL -O https://github.com/drone/drone-cli/releases/download/v1.2.1/drone_linux_amd64.tar.gz \
  && tar xvfz drone_linux_amd64.tar.gz \
  && rm -f drone_linux_amd64.tar.gz \
  && chmod 755 drone \
  && mv drone /usr/local/bin/

RUN curl -sSL -O https://github.com/gohugoio/hugo/releases/download/v0.64.0/hugo_0.64.0_Linux-64bit.tar.gz \
  && tar xvfz hugo_0.64.0_Linux-64bit.tar.gz hugo \
  && rm -f hugo_0.64.0_Linux-64bit.tar.gz \
  && chmod 755 hugo \
  && mv hugo /usr/local/bin/

RUN mkdir -p /drone/themes && git clone https://github.com/defn/drone-hugo-theme /drone/themes/drone-hugo-theme

RUN curl -sSL -O https://github.com/github/hub/releases/download/v2.14.1/hub-linux-amd64-2.14.1.tgz \
  && tar xfz hub-linux-amd64-2.14.1.tgz \
  && rm -f hub-linux-amd64-2.14.1.tgz \
  && chmod 755 hub-linux-amd64-2.14.1/bin/hub \
  && mv hub-linux-amd64-2.14.1/bin/hub /usr/local/bin/ \
  && rm -rf hub-linux-amd64-2.14.1

COPY plugin /plugin

ENTRYPOINT [ "/plugin" ]
