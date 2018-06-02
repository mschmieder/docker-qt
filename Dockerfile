FROM ubuntu:16.04
MAINTAINER Matthias Schmieder <matthias.schmieder@stryker.com>

ENV DEBIAN_FRONTEND noninteractive

# Install core dependencies
RUN apt-get update && \
    apt-get install -y \
        gcc g++ build-essential xorg wget && \
    rm -rf /var/lib/apt/lists/*

COPY install_qt.sh install_qt_silent.qs.template /install/

ARG QT_INSTALL_PACKAGES="qt.qt5.5110.gcc_64"
ARG QT_INSTALL_DIR="/opt/qt"

RUN cd /install && \
    ./install_qt.sh --install-dir /opt/qt --install-dir "${QT_INSTALL_DIR}" --packages "${QT_INSTALL_PACKAGES}" && \
    rm -rf /install

RUN export QT_BIN_DIR=$(dirname $(find /opt/qt -name "qmake" | tail -n1))

ENV PATH=$QT_BIN_DIR:$PATH