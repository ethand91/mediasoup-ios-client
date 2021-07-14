#!/bin/bash

# Stop script on errors.
set -e

# Define working directories.
export PROJECT_DIR=$(pwd)
echo "PROJECT_DIR = $PROJECT_DIR"
export WORK_DIR=$(pwd)/work
echo "WORK_DIR = $WORK_DIR"
export BUILD_DIR=$(pwd)/build
echo "BUILD_DIR = $BUILD_DIR"
export PATCHES_DIR=$(pwd)/patches
echo "PATCHES_DIR = $PATCHES_DIR"
export WEBRTC_DIR=$PROJECT_DIR/mediasoup-client-ios/dependencies/webrtc/src
echo "WEBRTC_DIR = $WEBRTC_DIR"

# Prepare directories.
if [ -d $BUILD_DIR ]
then
	echo 'Removing old build dir'
	rm -rf $BUILD_DIR
fi
mkdir -p $BUILD_DIR
echo 'BUILD_DIR created'

if [ -d $WORK_DIR ]
then
echo 'Removing old work dir'
	rm -rf $WORK_DIR
fi
mkdir -p $WORK_DIR
echo 'WORK_DIR created'

# Get depot tools.
cd $WORK_DIR
echo 'Cloning depot_tools'
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$WORK_DIR/depot_tools:$PATH

# ??? От этого наверное надо избавиться!!!
# ??? Get mediasoup-ios-client.
# ??? cd $WORK_DIR
# ??? echo 'Cloning mediasoup-ios-client'
# ??? git clone https://github.com/fedulvtubudul/mediasoup-ios-client.git

# Get libmediasoupclient.
cd $PROJECT_DIR/mediasoup-client-ios/dependencies
echo 'Cloning libmediasoupclient'
rm -rf libmediasoupclient
git clone https://github.com/VLprojects/libmediasoupclient.git

# Get WebRTC.
cd $WORK_DIR
echo 'Cloning WebRTC'
mkdir webrtc-ios
cd webrtc-ios
fetch --nohooks webrtc_ios
gclient sync
cd src

# Старая версия которую использовали Sequenia.
# ??? git checkout -b m85 refs/remotes/branch-heads/4183

git checkout -b m92 refs/remotes/branch-heads/4515

# Эта версия собирается уже в .xcframework 
# и содержит три архитектуры: device:arm64, simulator:x86_64, simulator:arm64.
# Но при использовании фреймворка в таком формате не удалось собрать
# mediasoup-ios-client из-за проблем с линковкой (не хватало символов из WebRTC).
#
# git checkout -b bh4574 refs/remotes/branch-heads/4574

gclient sync

# Вроде бы не надо на версии bh4574 (да и на m92 видимо тоже).
# Apply patches to make it buildable with Xcode.
# cp $PATCHES_DIR/find_sdk.py $WORK_DIR/webrtc-ios/src/build/mac/
# patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/rtc_stats.patch
# patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/str_cat.patch
# patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/RTCStatisticsReport.patch
patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/BUILD.patch


# echo "all downloaded"
# exit 0

# А этот патч надо ??
# cp $PATCHES_DIR/byte_order.h $WORK_DIR/webrtc-ios/src/rtc_base/


# Build WebRTC.
cd $WORK_DIR/webrtc-ios/src/
rm -rf out_ios_libs
# enable bitcode:
# --bitcode
# set output directory:
# -o '$BUILD_DIR/libwebrtc/'
python tools_webrtc/ios/build_ios_libs.py --extra-gn-args='is_component_build=false use_xcode_clang=true rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'


## Не понятно, надо ли всё это на новом формате фреймворков (на bh4574)? Вроде не надо.
cd out_ios_libs
ninja -C arm64_libs/ webrtc
ninja -C x64_libs/ webrtc
# Create WebRTC universal (fat) library.
mkdir -p universal
lipo -create arm64_libs/obj/libwebrtc.a x64_libs/obj/libwebrtc.a -output universal/libwebrtc.a


#echo "webrtc compiled"
#exit 0

# Build mediasoup-ios-client.
mv $WORK_DIR/webrtc-ios/src/* $WEBRTC_DIR

cd $PROJECT_DIR/mediasoup-client-ios/dependencies/

# Build mediasoup-client-ios for devices.
cmake . -Bbuild_ios_arm64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$WEBRTC_DIR/out_ios_libs/universal \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphone \
	-DIOS_ARCHS="arm64" \
	-DPLATFORM=OS64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
make -C build_ios_arm64

# Build mediasoup-client-ios for simulators.
cmake . -Bbuild_sim_x86_64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$WEBRTC_DIR/out_ios_libs/universal \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphonesimulator \
	-DIOS_ARCHS="x86_64" \
	-DPLATFORM=SIMULATOR64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
make -C build_sim_x86_64

# Can't be added to FAT library anyway, so can be skipped. Should be used when switched to new .xcframework format.
# cmake . -Bbuild_sim_arm64 \
# 	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
# 	-DLIBWEBRTC_BINARY_PATH=$WEBRTC_DIR/out_ios_libs/universal \
# 	-DMEDIASOUP_LOG_TRACE=ON \
# 	-DMEDIASOUP_LOG_DEV=ON \
# 	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
# 	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
# 	-DIOS_SDK=iphonesimulator \
# 	-DIOS_ARCHS="arm64"
# make -C build_sim_arm64


# Create a FAT libmediasoup / libsdptransform library

mkdir -p libmediasoupclient/lib
lipo -create \
	build_ios_arm64/libmediasoupclient/libmediasoupclient.a \
	build_sim_x86_64/libmediasoupclient/libmediasoupclient.a \
	-output libmediasoupclient/lib/libmediasoupclient.a

lipo -create \
	build_ios_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
	build_sim_x86_64/libmediasoupclient/libsdptransform/libsdptransform.a \
	-output libmediasoupclient/lib/libsdptransform.a

# Пока не поддерживаем, потом надо будет добавить в соответствующие места, после перехода на .xcfreamework.
# ??? build_sim_arm64/libmediasoupclient/libmediasoupclient.a \
# ??? build_sim_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \

cp $PATCHES_DIR/byte_order.h $PROJECT_DIR/mediasoup-client-ios/dependencies/webrtc/src/rtc_base/
open $PROJECT_DIR/mediasoup-client-ios.xcodeproj
