FROM letfn/container AS download

WORKDIR /tmp

RUN curl -sSL -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod 755 jq

RUN curl -sSL -o kaniko https://github.com/recur/kaniko/releases/download/v2-develop/executor-linux-amd64-v2-develop && chmod 755 kaniko

FROM amd64/busybox:musl as busybox

FROM gcr.io/kaniko-project/executor:debug-v0.17.1

COPY --from=busybox /bin/busybox /bin/sh
COPY --from=busybox /bin/busybox /bin/busybox
COPY --from=download /tmp/jq /bin/jq
COPY --from=download /tmp/kaniko /bin/executor

ENV BENCHMARK_FILE=/drone/src/benchmark/build.json

RUN /bin/busybox --install /bin

COPY plugin /plugin

ENTRYPOINT [ "/plugin" ]
