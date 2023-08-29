#!/bin/bash
PKG_CONFIG_PATH="/opt/brew/opt/libxml2/lib/pkgconfig:$PWD/../local/lib/pkgconfig" qmake PREFIX=$PWD/../local
