#!/bin/bash
export PATH=$(dirname $(find ${QT_INSTALL_DIR} -type f -executable -name 'qmake' | tail -n1)):$PATH
export PATH=$(dirname $(find ${QT_INSTALL_DIR} -type f -executable -name 'qbs' | tail -n1)):$PATH

exec "$@"