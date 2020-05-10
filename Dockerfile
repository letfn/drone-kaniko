FROM letfn/container AS download

WORKDIR /tmp

RUN curl -sSL -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod 755 jq

FROM amd64/busybox:musl as busybox

FROM gcr.io/kaniko-project/executor:debug-v0.22.0

COPY --from=busybox /bin/busybox /bin/sh
COPY --from=busybox /bin/busybox /bin/busybox
COPY --from=download /tmp/jq /bin/jq

ENV BENCHMARK_FILE=/drone/src/benchmark/build.json

RUN /bin/busybox --install /bin

COPY plugin /plugin

ENTRYPOINT [ "/plugin" ]
