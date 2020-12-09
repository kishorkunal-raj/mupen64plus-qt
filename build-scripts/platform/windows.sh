#!/bin/bash

[[ -z $WORKING_DIR ]] && WORKING_DIR=$(pwd)
[[ -z $VERSION ]] && VERSION=$(git log --oneline -n 1 | awk '{print $1}')

[[ -z $ARCH ]] && ARCH=".$(uname -m)"
[[ $ARCH == ".x86_64" ]] || [[ $ARCH == "ppc64le" ]] && ARCH=""


case "$1" in

    'setup_qt')
        cd "$WORKING_DIR/../"
	echo "WORKDIR ---> $WORKING_DIR"
	echo "WORKING_DIR -------> $WORKING_DIR/../"
        echo "Pwd is ---------------------> $PWD"
        echo "=========================== $BUILD_MXE_QT"
        if [[ $BUILD_MXE_QT ]]; then
            # Build Qt with mxe
            sudo apt-get update -qq
            sudo apt-get install \
                autoconf automake autopoint bash bison bzip2 cmake flex \
                gettext git g++ gperf intltool libffi-dev libtool \
                libltdl-dev libssl-dev libxml-parser-perl make openssl \
                p7zip-full patch perl pkg-config python ruby scons sed \
                unzip wget xz-utils libtool-bin lzip libgdk-pixbuf2.0-dev
            git clone https://github.com/mxe/mxe.git
            cd mxe
	    echo "Pwd in if section ---------------------> $PWD"
            make qtbase
        else
            # Fetch pre-built mxe Qt
	    echo "Pwd  else section is ---------------------> $PWD"
            wget https://www.dropbox.com/s/jr6l4lnixizqtln/travis-mxe-qt5.tar.gz
            tar -xvzf travis-mxe-qt5.tar.gz > /dev/null

        fi
        #mkdir -p $WORKING_DIR/mupen64plus-qt
	ls
        cd "$WORKING_DIR/../mupen64plus-qt"
	ls

    ;;

    'get_quazip')
        wget http://downloads.sourceforge.net/quazip/quazip-0.7.3.tar.gz
        tar -xvzf quazip-0.7.3.tar.gz > /dev/null
        mv quazip-0.7.3/quazip quazip5
	ls
	echo "pwd ------>quazip ---> $(pwd)"
    ;;

    'build')
        export PATH="$PATH:$WORKING_DIR/../mxe/usr/bin"
	echo "working dir $WORKING_DIR"
	ls $WORKING_DIR
	echo "WORKING_DIR/../"
	ls $WORKING_DIR/../
	echo "Pwd in build ---------------------> $(pwd)"
	ls $(pwd)
	echo "Current directiorey"
	ls
        ./build-scripts/revision.sh
	#cd $WORKING_DIR/../
        i686-w64-mingw32.static-qmake-qt5
        make
    ;;

    'package')
        mkdir -p "build/$TRAVIS_BRANCH"

        mv release/mupen64plus-qt.exe resources/README.txt .
        zip "build/$TRAVIS_BRANCH/mupen64plus-qt_win_$VERSION$ARCH.zip" mupen64plus-qt.exe README.txt
    ;;

esac
