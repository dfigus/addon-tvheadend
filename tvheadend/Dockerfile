ARG BUILD_FROM

FROM alpine:3.18 AS builder
############## builder ##############

# package versions
ARG ARGTABLE_VER="2.13"

# environment settings
ARG TZ="Etc/UTC"
ARG TVHEADEND_COMMIT="4825b8414fc276ee74e9d0c3ebf5eaf09825d6b6"
ENV HOME="/config"

COPY argtable2_config/ /tmp/argtable2_config/

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN \
    echo "**** install build packages ****" && \
    apk add --no-cache \
    jq \
    curl \
    bash \
    autoconf \
    automake \
    bsd-compat-headers \
    build-base \
    cmake \
    coreutils \
    dbus-dev \
    ffmpeg4-dev \
    file \
    findutils \
    gettext-dev \
    git \
    gnu-libiconv-dev \
    libdvbcsa-dev \
    libgcrypt-dev \
    libhdhomerun-dev \
    libtool \
    libva-dev \
    libvpx-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    openssl-dev \
    opus-dev \
    patch \
    pcre2-dev \
    pkgconf \
    pngquant \
    python3 \
    sdl2-dev \
    uriparser-dev \
    x264-dev \
    x265-dev \
    zlib-dev

RUN \
    echo "**** remove musl iconv.h and replace with gnu-iconv.h ****" && \
    rm -rf /usr/include/iconv.h && \
    cp /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h

RUN \
    echo "**** compile tvheadend ****" && \
    if [ -z ${TVHEADEND_COMMIT+x} ]; then \
    TVHEADEND_COMMIT=$(curl -sX GET https://api.github.com/repos/tvheadend/tvheadend/commits/master \
    | jq -r '. | .sha'); \
    fi && \
    mkdir -p \
    /tmp/tvheadend && \
    git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
    cd /tmp/tvheadend && \
    git checkout "${TVHEADEND_COMMIT}" && \
    ./configure \
    `#Encoding` \
    --disable-ffmpeg_static \
    --disable-libfdkaac_static \
    --disable-libtheora_static \
    --disable-libopus_static \
    --disable-libvorbis_static \
    --disable-libvpx_static \
    --disable-libx264_static \
    --disable-libx265_static \
    --disable-libfdkaac \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    \
    `#Options` \
    --disable-avahi \
    --disable-dbus_1 \
    --disable-bintray_cache \
    --disable-execinfo \
    --disable-hdhomerun_static \
    --enable-hdhomerun_client \
    --enable-libav \
    --enable-pngquant \
    --enable-trace \
    --enable-vaapi \
    --infodir=/usr/share/info \
    --localstatedir=/var \
    --mandir=/usr/share/man \
    --prefix=/usr \
    --python=python3 \
    --sysconfdir=/config && \
    make -j 2 && \
    make DESTDIR=/tmp/tvheadend-build install

RUN \
    echo "**** compile argtable2 ****" && \
    ARGTABLE_VER1="${ARGTABLE_VER//./-}" && \
    mkdir -p \
    /tmp/argtable && \
    curl -s -o \
    /tmp/argtable-src.tar.gz -L \
    "https://sourceforge.net/projects/argtable/files/argtable/argtable-${ARGTABLE_VER}/argtable${ARGTABLE_VER1}.tar.gz" && \
    tar xf \
    /tmp/argtable-src.tar.gz -C \
    /tmp/argtable --strip-components=1 && \
    cp /tmp/argtable2_config/config.* /tmp/argtable && \
    cd /tmp/argtable && \
    ./configure \
    --prefix=/usr && \
    make -j 2 && \
    make check && \
    make DESTDIR=/tmp/argtable-build install && \
    echo "**** copy to /usr for comskip dependency ****" && \
    cp -pr /tmp/argtable-build/usr/* /usr/

RUN \
    echo "***** compile comskip ****" && \
    git clone https://github.com/erikkaashoek/Comskip /tmp/comskip && \
    cd /tmp/comskip && \
    ./autogen.sh && \
    ./configure \
    --bindir=/usr/bin \
    --sysconfdir=/config/comskip && \
    make -j 2 && \
    make DESTDIR=/tmp/comskip-build install

####### runtime ###########

# hadolint ignore=DL3006
FROM ${BUILD_FROM}

COPY requirements.txt /tmp/

RUN \
    apk update \
    && apk add --no-cache --virtual .build-deps \
    musl-dev=1.2.4-r2 \
    gcc=12.2.1_git20220924-r10 \
    g++=12.2.1_git20220924-r10 \
    libxml2-dev=2.11.6-r0 \
    libxslt-dev=1.1.38-r0 \
    python3-dev=3.11.6-r0 \
    && apk add --no-cache \
    bsd-compat-headers=0.7.2-r5 \
    ffmpeg=6.0.1-r0 \
    ffmpeg4-libavcodec=4.4.4-r1 \
    ffmpeg4-libavdevice=4.4.4-r1 \
    ffmpeg4-libavfilter=4.4.4-r1 \
    ffmpeg4-libavformat=4.4.4-r1 \
    ffmpeg4-libavutil=4.4.4-r1 \
    ffmpeg4-libpostproc=4.4.4-r1 \
    ffmpeg4-libswresample=4.4.4-r1 \
    ffmpeg4-libswscale=4.4.4-r1 \
    gnu-libiconv=1.17-r1 \
    libdvbcsa=1.1.0-r1 \
    libhdhomerun-libs=20200225-r1 \
    libva=2.18.0-r1 \
    libvpx=1.13.0-r2 \
    libxml2=2.11.6-r0	 \
    libxslt=1.1.38-r0 \
    linux-headers=6.3-r0 \
    mesa-va-gallium=23.0.4-r0 \
    opus=1.4-r0	 \
    pcre2=10.42-r1	 \
    perl=5.36.2-r0	 \
    perl-datetime-format-strptime=1.79-r0 \
    perl-json=4.10-r0 \
    perl-json-xs=4.03-r2 \
    py3-requests=2.31.0-r0 \
    python3=3.11.6-r0 \
    uriparser=0.9.7-r0 \
    x264=0.164_git20220602-r1 \
    x265=3.5-r4 \
    xmltv=1.2.1-r3 \
    zlib=1.2.13-r1 \
    py3-pip=23.1.2-r0 \
    libxslt=1.1.38-r0 \
    nginx=1.24.0-r7\
    && pip3 install \
    --no-cache-dir \
    --prefer-binary \
    -r /tmp/requirements.txt \
    && apk del --no-cache --purge .build-deps

COPY --from=builder /tmp/argtable-build/usr/ /usr/
COPY --from=builder /tmp/comskip-build/usr/ /usr/
COPY --from=builder /tmp/tvheadend-build/usr/ /usr/

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Daniel Figus <10271668+dfigus@users.noreply.github.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="dfigus" \
    org.opencontainers.image.authors="Daniel Figus <10271668+dfigus@users.noreply.github.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/dfigus/addon-tvheadend" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
