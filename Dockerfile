# syntax=docker/dockerfile:1
ARG DEBIAN_VERSION=buster-slim
FROM debian:${DEBIAN_VERSION}
LABEL maintainer "urothis@gmail.com"
ARG TARGETOS TARGETARCH NWN_IMAGE_BUILD_DATE NWN_VERSION
COPY docker/data/bin/${TARGETOS}-${TARGETARCH}/nwserver /nwn/data/bin/${TARGETOS}-${TARGETARCH}/nwserver
COPY docker/data/data /nwn/data/data
COPY docker/data/lang/ /nwn/data/lang/

COPY scripts/run-server.sh /nwn/run-server.sh
COPY scripts/prep-nwn-ini.awk /nwn/prep-nwn-ini.awk
COPY scripts/prep-nwnplayer-ini.awk /nwn/prep-nwnplayer-ini.awk
COPY DockerDemo.mod /nwn/data/data/mod/DockerDemo.mod

RUN apt-get update && \
  apt-get --no-install-recommends -y install libc6 libstdc++6 && \
  rm -r /var/cache/apt /var/lib/apt/lists
RUN mkdir -p /nwn/home /nwn/run
RUN chmod +x /nwn/run-server.sh
VOLUME /nwn/home
EXPOSE ${NWN_PORT:-5121}/udp
ENV NWN_TAIL_LOGS=y
ENV NWN_EXTRA_ARGS="-userdirectory /nwn/run"
ENV NWN_IMAGE_BUILD_DATE=${BUILD_DATE}
ENV NWN_VERSION=${NWN_VERSION}
WORKDIR /nwn/data/bin/${TARGETOS}-${TARGETARCH}
RUN chmod +x nwserver
ENTRYPOINT ["/bin/bash", "/nwn/run-server.sh"]
