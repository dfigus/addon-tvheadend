ARG BUILD_FROM

FROM alpine:3.21 AS builder
############## builder ##############

# package versions
ARG ARGTABLE_VER="2.13"
ARG TVHEADEND_COMMIT="cf29292592756f778024b3f5d8df166dad899285"
ARG COMSKIP_COMMIT="a140b6ac8bc8f596729e9052819affc779c3b377"
ARG COMCHAP_COMMIT="dd7db30c258e965f282ac78825971dd0703a031e"

# environment settings
ARG TZ="Etc/UTC"

ENV HOME="/config"

COPY argtable2_config/ /tmp/argtable2_config/

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN \
    echo "**** install build packages ****" && \
    apk add --no-cache \
    jq=1.7.1-r0	\
    curl=8.12.1-r1 \
    bash=5.2.37-r0 \
    autoconf=2.72-r0 \
    automake=1.17-r0 \
    bsd-compat-headers=0.7.2-r6 \
    build-base=0.5-r3 \
    cmake=3.31.1-r0 \
    coreutils=9.5-r2 \
    dbus-dev=1.14.10-r4 \
    ffmpeg4-dev=4.4.5-r1 \
    file=5.46-r2 \
    findutils=4.10.0-r0 \
    gettext-dev=0.22.5-r0 \
    git=2.47.2-r0 \
    gnu-libiconv-dev=1.17-r2 \
    libdvbcsa-dev=1.1.0-r1 \
    libgcrypt-dev=1.10.3-r1	\
    libhdhomerun-dev=20200225-r1 \
    libtool=2.4.7-r3 \
    libva-dev=2.22.0-r1 \
    libvpx-dev=1.15.0-r0 \
    libxml2-dev=2.13.4-r6 \
    libxslt-dev=1.1.42-r2 \
    linux-headers=6.6-r1 \
    openssl-dev=3.3.3-r0 \
    opus-dev=1.5.2-r1 \
    patch=2.7.6-r10 \
    pcre2-dev=10.43-r0 \
    pkgconf=2.3.0-r0 \
    pngquant=3.0.3-r0 \
    python3=3.12.10-r0 \
    sdl2-dev=2.30.9-r0 \
    uriparser-dev=0.9.8-r0 \
    x264-dev=0.164.3108-r0 \
    x265-dev=3.6-r0 \
    zlib-dev=1.3.1-r2

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
    cp /tmp/argtable2_config/*.patch /tmp/argtable && \
    patch -p1 < fix-implicit-function-declaration.patch && \
    patch -p1 < fix-undeclared-library-function.patch && \
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

RUN \
    echo "***** compile comskip ****" && \
    git clone https://github.com/BrettSheleski/comchap /tmp/comchap && \
    cd /tmp/comchap && \
    git checkout "${COMCHAP_COMMIT}"


####### runtime ###########

# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ARG PICONS_RELEASE="2025-05-10--15-47-22"

COPY requirements.txt /tmp/

RUN \
    apk update \
    && apk add --no-cache --virtual .build-deps \
    musl-dev=1.2.5-r9 \
    gcc=14.2.0-r4 \
    g++=14.2.0-r4 \
    libxml2-dev=2.13.4-r6 \
    libxslt-dev=1.1.42-r2 \
    python3-dev=3.12.10-r0 \
    && apk add --no-cache \
    bsd-compat-headers=0.7.2-r6 \
    ffmpeg4=4.4.5-r1 \
    ffmpeg=6.1.2-r1	\
    ffmpeg4-libavcodec=4.4.5-r1 \
    ffmpeg4-libavdevice=4.4.5-r1 \
    ffmpeg4-libavfilter=4.4.5-r1 \
    ffmpeg4-libavformat=4.4.5-r1 \
    ffmpeg4-libavutil=4.4.5-r1 \
    ffmpeg4-libpostproc=4.4.5-r1 \
    ffmpeg4-libswresample=4.4.5-r1 \
    ffmpeg4-libswscale=4.4.5-r1 \
    gnu-libiconv=1.17-r2 \
    libdvbcsa=1.1.0-r1 \
    libhdhomerun-libs=20200225-r1 \
    libva=2.22.0-r1 \
    libvpx=1.15.0-r0 \
    libxml2=2.13.4-r6 \
    libxslt=1.1.42-r2 \
    linux-headers=6.6-r1 \
    opus=1.5.2-r1	 \
    pcre2=10.43-r0	 \
    perl=5.40.1-r1	 \
    perl-datetime-format-strptime=1.79-r1 \
    perl-json=4.10-r1 \
    perl-json-xs=4.03-r5 \
    py3-requests=2.32.3-r0 \
    python3=3.12.10-r0 \
    uriparser=0.9.8-r0 \
    x264=0.164.3108-r0 \
    x265=3.6-r0 \
    xmltv=1.3.0-r1 \
    zlib=1.3.1-r2 \
    py3-pip=24.3.1-r0 \
    libxslt=1.1.42-r2 \
    nginx=1.26.3-r0 \
    linux-firmware-other=20241210-r0 \
    dotnet8-runtime=8.0.15-r0 \
    xmlstarlet=1.6.1-r2 \
    && pip3 install \
    --no-cache-dir \
    --prefer-binary \
    -r /tmp/requirements.txt \
    && apk del --no-cache --purge .build-deps

COPY --from=builder /tmp/argtable-build/usr/ /usr/
COPY --from=builder /tmp/comskip-build/usr/ /usr/
COPY --from=builder /tmp/tvheadend-build/usr/ /usr/
COPY --from=builder /tmp/comchap/comchap /usr/bin/comchap
COPY --from=builder /tmp/comchap/comcut /usr/bin/comcut

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

# install WebGrab+
RUN \
   mkdir -p /wg/tmp \
&& wget -q -O /wg/tmp/wg.tar.gz https://www.webgrabplus.com/sites/default/files/download/SW/V5.3.0/WebGrabPlus_V5.3_install.tar.gz \
&& tar -zxvf /wg/tmp/wg.tar.gz -C /wg \
&& /wg/.wg++/install.sh \
&& sed -i "s|<filename>guide.xml</filename>|<filename>/config/tvheadend/wg++/guide.xml</filename>|g" /wg/.wg++/WebGrab++.config.xml \
&& rm -rf /wg/tmp \
&& wget -q -O /usr/bin/tv_grab_wg++ https://www.webgrabplus.com/sites/default/files/tv_grab_wg.txt \
&& sed -i 's|~/.wg++/guide.xml|/config/tvheadend/wg++/guide.xml|g' /usr/bin/tv_grab_wg++ \
&& chmod +x /usr/bin/tv_grab_wg++

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
