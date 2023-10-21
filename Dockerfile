FROM ubuntu:23.04 as build0

# formerly 8966a64
ENV _ver=7681c50
CMD ["/bin/bash"]
SHELL ["/bin/bash", "-c"]

RUN echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        autoconf \
        automake \
        autopoint \
        bash \
        binutils \
        bison \
        bzip2 \
        ca-certificates \
        flex \
        g++ \
        g++-multilib \
        gettext \
        git \
        gperf \
        intltool \
        libc6-dev-i386 \
        libgdk-pixbuf2.0-dev \
        libltdl-dev \
		libgl-dev \
		libpcre3-dev \
        libssl-dev \
        libtool \
        libtool-bin \
        libxml-parser-perl \
        make \
        openssl \
        p7zip-full \
        patch \
        perl \
        pkg-config \
        python3 \
		python3-distutils \
		python3-mako \
		python3-pkg-resources \
		python-is-python3 \
        ruby \
        sed \
        unzip \
        wget \
        xz-utils \
        lzip \
        scons

FROM build0 as build1

RUN mkdir -p /win
RUN cd /win && git clone https://github.com/mxe/mxe.git && cd mxe && git checkout ${_ver} && sed -i "s|DEFAULT_MAX_JOBS := 6|DEFAULT_MAX_JOBS := 12|" Makefile;

FROM build1 as build2

COPY settings.mk /win/mxe/settings.mk
RUN set -o pipefail ; cd /win/mxe && make --jobs=12 JOBS=12 download 2>&1 | tee mxe-build.log

FROM build2 as build3

RUN set -o pipefail ; cd /win/mxe && make --jobs=12 JOBS=12 2>&1 | tee -a mxe-build.log

FROM build3 as build4

COPY qtconnectivity-1.patch /win/mxe/src/qtconnectivity-1.patch
COPY qtconnectivity-2.patch /win/mxe/src/qtconnectivity-2.patch
COPY lower_copy.sh /win/mxe/
COPY winrt /win/mxe/winrt
RUN cd /win/mxe/winrt && /win/mxe/lower_copy.sh && mkdir /win/mxe/winrt_ && cp -r /win/mxe/winrt /win/mxe/winrt_ && mv /win/mxe/winrt_/winrt /win/mxe/winrt/ && cp -r /win/mxe/winrt/* /win/mxe/usr/x86_64-w64-mingw32.shared/qt5/include
RUN touch /win/mxe/src/qtconnectivity.mk && cd /win/mxe && make --jobs=12 JOBS=12 2>&1 | tee mxe-build-2.log
