# syntax=docker/dockerfile:1

ARG ALPINE_VERSION=3.23
FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL org.opencontainers.image.title="jre21-alpine"
LABEL org.opencontainers.image.description="Personal Alpine Linux image with patched OpenJDK 21 JRE"

# BusyBox is inherited from Alpine and provides /bin/sh.
# Keep it explicit so the build fails if Alpine cannot provide the patched revision.
RUN set -eux; \
    printf '%s\n' \
        "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main" \
        "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community" \
        > /etc/apk/repositories; \
    apk upgrade --no-cache --available; \
    apk add --no-cache \
        'busybox>=1.37.0-r30' \
        'busybox-binsh>=1.37.0-r30' \
        'libcrypto3>=3.5.6-r0' \
        'libssl3>=3.5.6-r0' \
        'musl>=1.2.5-r23' \
        'musl-utils>=1.2.5-r23' \
        'zlib>=1.3.2-r0' \
        ca-certificates \
        'openjdk21-jre-headless>=21.0.10_p7-r0' \
        tzdata; \
    update-ca-certificates; \
    java -version; \
    apk info -vv | sort > /etc/apk/installed-packages.txt; \
    rm -rf /tmp/*

ENV JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV LANG="C.UTF-8"

CMD ["java", "-version"]
