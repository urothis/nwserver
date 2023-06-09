# syntax=docker/dockerfile:1
ARG DEBIAN_VERSION=buster-slim
FROM debian:${DEBIAN_VERSION}
LABEL maintainer "urothis@gmail.com"
ARG TARGETOS TARGETARCH NWN_IMAGE_BUILD_DATE NWN_VERSION
COPY docker_data/data/data /nwn/data/data
COPY docker_data/run-server.sh /nwn/run-server.sh
COPY docker_data/prep-nwn-ini.awk /nwn/prep-nwn-ini.awk
COPY docker_data/prep-nwnplayer-ini.awk /nwn/prep-nwnplayer-ini.awk
COPY docker_data/data/bin/${TARGETOS}-${TARGETARCH}/nwserver /nwn/data/bin/${TARGETOS}-${TARGETARCH}/nwserver
COPY docker_data/lang/ /nwn/data/lang/
COPY DockerDemo.mod /nwn/data/data/mod/
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
