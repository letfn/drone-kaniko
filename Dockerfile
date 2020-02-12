FROM letfn/container AS download

RUN curl -sSL -o /usr/local/bin/kaniko https://github.com/recur/kaniko/releases/download/v-develop/executor-linux-amd64-v-develop && chmod 755 /usr/local/bin/kaniko

WORKDIR /tmp

FROM amd64/busybox:musl as busybox

FROM gcr.io/kaniko-project/executor:debug-v0.17.1

COPY --from=busybox /bin/busybox /bin/sh
COPY --from=busybox /bin/busybox /bin/busybox
COPY --from=download /usr/local/bin/kaniko /bin/executor

ENV PATH /bin:/kaniko

RUN /bin/busybox --install /bin

WORKDIR /drone/src

COPY plugin /plugin

ENTRYPOINT [ "/plugin" ]
