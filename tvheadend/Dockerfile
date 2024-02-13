ARG BUILD_FROM

FROM alpine:3.19 AS builder
############## builder ##############

# package versions
ARG ARGTABLE_VER="2.13"
ARG TVHEADEND_COMMIT="6b5defc76d71c184a5a7a5e82f2a9c0eaf3a65f3"
ARG COMSKIP_COMMIT="109b5d10b086d299d7e43878ccc7951cb7133ed8"

# environment settings
ARG TZ="Etc/UTC"

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
    mkdir -p \
    /tmp/tvheadend && \
    git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
    cd /tmp/tvheadend && \
    git checkout "${TVHEADEND_COMMIT}" && \
# patch cookie handling in extjs
    sed -i 's/document\.cookie="ys-"+a/document\.cookie="ys-"+encodeURIComponent(a)/g' /tmp/tvheadend/vendor/ext-3.4/ext-all.js && \
    sed -i 's/a\.substr(3)/decodeURIComponent(a\.substr(3))/g' /tmp/tvheadend/vendor/ext-3.4/ext-all.js && \
    sed -i 's/document\.cookie = "ys-"+ name/ document\.cookie = "ys-"+ encodeURIComponent(name)/g' /tmp/tvheadend/vendor/ext-3.4/ext-all-debug.js && \
    sed -i 's/document\.cookie = "ys-" + name/ document\.cookie = "ys-"+ encodeURIComponent(name)/g' /tmp/tvheadend/vendor/ext-3.4/ext-all-debug.js && \
    sed -i 's/name\.substr(3)/decodeURIComponent(name\.substr(3))/g' /tmp/tvheadend/vendor/ext-3.4/ext-all-debug.js && \
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
    git checkout "${COMSKIP_COMMIT}" && \
    ./autogen.sh && \
    ./configure \
    --bindir=/usr/bin \
    --sysconfdir=/config/comskip && \
    make -j 2 && \
    make DESTDIR=/tmp/comskip-build install

####### runtime ###########

# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ARG PICONS_RELEASE="2024-02-10--23-31-45"

COPY requirements.txt /tmp/

RUN \
    apk update \
    && apk add --no-cache --virtual .build-deps \
    musl-dev=1.2.4_git20230717-r4 \
    gcc=13.2.1_git20231014-r0 \
    g++=13.2.1_git20231014-r0 \
    libxml2-dev=2.11.6-r0 \
    libxslt-dev=1.1.39-r0 \
    python3-dev=3.11.6-r1 \
    && apk add --no-cache \
    bsd-compat-headers=0.7.2-r5 \
    ffmpeg=6.1.1-r0 \
    ffmpeg4-libavcodec=4.4.4-r5 \
    ffmpeg4-libavdevice=4.4.4-r5 \
    ffmpeg4-libavfilter=4.4.4-r5 \
    ffmpeg4-libavformat=4.4.4-r5 \
    ffmpeg4-libavutil=4.4.4-r5 \
    ffmpeg4-libpostproc=4.4.4-r5 \
    ffmpeg4-libswresample=4.4.4-r5 \
    ffmpeg4-libswscale=4.4.4-r5 \
    gnu-libiconv=1.17-r2 \
    libdvbcsa=1.1.0-r1 \
    libhdhomerun-libs=20200225-r1 \
    libva=2.20.0-r0 \
    libvpx=1.13.1-r0 \
    libxml2=2.11.7-r0 \
    libxslt=1.1.39-r0 \
    linux-headers=6.5-r0 \
#    mesa-va-gallium=23.3.1-r0 \ AMD Driver not required
    opus=1.4-r0	 \
    pcre2=10.42-r2	 \
    perl=5.38.2-r0	 \
    perl-datetime-format-strptime=1.79-r1 \
    perl-json=4.10-r1 \
    perl-json-xs=4.03-r3 \
    py3-requests=2.31.0-r1 \
    python3=3.11.6-r1 \
    uriparser=0.9.7-r0 \
    x264=0.164_git20231001-r0 \
    x265=3.5-r4 \
    xmltv=1.2.1-r4 \
    zlib=1.3.1-r0 \
    py3-pip=23.3.1-r0 \
    libxslt=1.1.39-r0 \
    nginx=1.24.0-r15 \
    && pip3 install \
    --no-cache-dir \
    --prefer-binary \
    -r /tmp/requirements.txt \
    && apk del --no-cache --purge .build-deps

COPY --from=builder /tmp/argtable-build/usr/ /usr/
COPY --from=builder /tmp/comskip-build/usr/ /usr/
COPY --from=builder /tmp/tvheadend-build/usr/ /usr/

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN \
  mkdir -p /picons/tmp \
  mkdir /picons/snp \
  mkdir /picons/srp \
  && curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/picons/picons/releases/tags/"${PICONS_RELEASE}" > /picons/tmp/release.json \
  && jq -r '.assets[] | select(.name | test("^snp-full\\.220x132-190x102\\.light\\.on\\.transparent.*symlink\\.tar\\.xz$")) | .browser_download_url' /picons/tmp/release.json | xargs wget -O /picons/tmp/snp.tar.xz \
  && jq -r '.assets[] | select(.name | test("^srp-full\\.220x132-190x102\\.light\\.on\\.transparent.*symlink\\.tar\\.xz$")) | .browser_download_url' /picons/tmp/release.json | xargs wget -O /picons/tmp/srp.tar.xz \
  && tar xfJ /picons/tmp/snp.tar.xz -C /picons/snp --strip-components=1 \
  && tar xfJ /picons/tmp/srp.tar.xz -C /picons/srp --strip-components=1 \
  && rm -rf /picons/tmp

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
