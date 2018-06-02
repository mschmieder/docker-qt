#!/bin/bash
# for available packages see
# https://github.com/qtproject/qtsdk/tree/master/packaging-tools/configurations/pkg_templates

function download_installer {
    # ONLINE INSTALLER 
    # Linux x64: "http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run"
    # Mac x64:   "http://download.qt.io/official_releases/online_installers/qt-unified-mac-x64-online.dmg"
    
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     
            installer_url="http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run"
            qt_unified_installer="qt-unified-linux-x64-online.run"
            ;;
        Darwin*)    
            installer_url="http://download.qt.io/official_releases/online_installers/qt-unified-mac-x64-online.dmg"
            qt_unified_installer="qt-unified-mac-x64-online.dmg"
            ;;
        *)          
    esac

    if [ ! -f "${qt_unified_installer}" ]; then
      echo "downloading unified installer from ${installer_url}"
      wget --quiet ${installer_url}
    fi

    case "${unameOut}" in
             Darwin*)   
                mounted_dmg=$(hdiutil attach ${qt_unified_installer} | tail -n1 | tr -d ' ' | tr '\t' ';' | cut -d";" -f3)
                echo "${mounted_dmg}"
                cp -r ${mounted_dmg}/*.app .
                hdiutil unmount "${mounted_dmg}"
                qt_unified_installer=$(find . -iname "qt-unified*-online")
                ;;
        *)          
    esac

    chmod +x ${qt_unified_installer} 
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -i|--install-dir)
    INSTALL_DIR="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--packages)
    PACKAGES="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "#########################################"
echo QT SILENT INSTALLER
echo "#########################################"
echo "->   Packages          = [${PACKAGES}]"
echo "->   Install Directory = [${INSTALL_DIR}]"

IFS=';' read -r -a packages <<< "${PACKAGES}"

PACKAGE_LIST=""
for package in "${packages[@]}"
do
    PACKAGE_LIST+="widget.selectComponent(\"${package}\");"
done

cp install_qt_silent.qs.template install_qt_silent.qs

# replace install directory
sed -i.bak "s,{{PACKAGE_LIST}},${PACKAGE_LIST},g" install_qt_silent.qs
sed -i.bak "s,{{INSTALL_DIR}},${INSTALL_DIR},g" install_qt_silent.qs

# get the unified installer
# this will set the variable 'qt_unified_installer'
download_installer

# run installer
./${qt_unified_installer} --platform minimal --silent --script install_qt_silent.qs #--verbose