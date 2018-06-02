# Docker Qt

Docker images that use QT's `unified installer` to install QT. You can specifiy when building the docker images which `QT components` you want to install into your system by providing a semicolon separated list of `package ids`

Available package ids can be determined following this [Link](https://github.com/qtproject/qtsdk/tree/master/packaging-tools/configurations/pkg_templates)

The silent installer `install_qt_silent.sh` also supports the installation on OS X systems.


## Building the docker image

```bash
docker build -t docker-qt:5.9.4 --build-arg QT_INSTALL_PACKAGES="qt.qt5.5110.gcc_64" --build-arg QT_INSTALL_DIR=/opt/qt
```

