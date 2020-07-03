FROM letfn/container AS download

WORKDIR /tmp

RUN curl -sSL -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod 755 jq

FROM gcr.io/kaniko-project/executor:debug-v0.24.0 as busybox

FROM gcr.io/kaniko-project/executor:debug-v0.24.0

COPY --from=download /tmp/jq /busybox/jq

COPY --from=busybox /busybox/busybox /bin/busybox

RUN [ "/bin/busybox", "--install", "/bin" ]

ENV BENCHMARK_FILE=/drone/src/benchmark/build.json
ENV PATH=/kaniko:/bin:/busybox

COPY plugin /plugin

ENTRYPOINT [ "/plugin" ]

RUN [ "/busybox/sh", "-c", "uname -a" ]
RUN [ "/bin/sh", "-c", "uname -a"]
