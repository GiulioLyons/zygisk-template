#!/bin/bash
PROJECT_NAME="zygisk_example"
PROJECT_DIR=$(pwd)
OUTDIR="output"
TEMPLATE="template/magisk_module"
NDK_PATH=/home/w00t/coding/android/android-ndk-r27c
PATH=$PATH:$NDK_PATH


if [ -d "$OUTDIR" ]; then
    rm -rf $OUTDIR
fi
mkdir $OUTDIR


cd module
ndk-build -j4
cd ..

cp -R $TEMPLATE $OUTDIR/$PROJECT_NAME
cp module.prop $OUTDIR/$PROJECT_NAME

mkdir -p $OUTDIR/$PROJECT_NAME/zygisk

for arch in $(ls module/libs); do cp module/libs/$arch/*.so $OUTDIR/$PROJECT_NAME/zygisk/$arch.so; done

cd $OUTDIR/$PROJECT_NAME

zip -r ../$PROJECT_NAME.zip ./*

cd $PROJECT_DIR

adb push $OUTDIR/$PROJECT_NAME.zip /data/local/tmp/

adb shell su -c magisk --install-module /data/local/tmp/$PROJECT_NAME.zip

adb shell reboot


