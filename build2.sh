#!/bin/bash

# TODO: добавить проверку архитектуры. Работет сейчас только на x86-64, если apple silicon - надо фейлить сборку.

# Stop script on errors.
set -e

# Define working directories.
export PROJECT_DIR=$(pwd)
echo "PROJECT_DIR = $PROJECT_DIR"
export WORK_DIR=$(pwd)/work
echo "WORK_DIR = $WORK_DIR"
export BUILD_DIR=$(pwd)/build
echo "BUILD_DIR = $BUILD_DIR"
export OUTPUT_DIR=$(pwd)/bin
echo "OUTPUT_DIR = $OUTPUT_DIR"
export PATCHES_DIR=$(pwd)/patches
echo "PATCHES_DIR = $PATCHES_DIR"
export WEBRTC_DIR=$PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src
echo "WEBRTC_DIR = $WEBRTC_DIR"

# Prepare directories.
# if [ -d $OUTPUT_DIR ]
# then
# 	echo 'Removing old output dir'
# 	rm -rf $OUTPUT_DIR
# fi
# mkdir -p $OUTPUT_DIR
# echo 'OUTPUT_DIR created'

# if [ -d $BUILD_DIR ]
# then
# 	echo 'Removing old build dir'
# 	rm -rf $BUILD_DIR
# fi
# mkdir -p $BUILD_DIR
# echo 'BUILD_DIR created'

# if [ -d $WORK_DIR ]
# then
# echo 'Removing old work dir'
# 	rm -rf $WORK_DIR
# fi
# mkdir -p $WORK_DIR
# echo 'WORK_DIR created'

# Get depot tools.
# cd $WORK_DIR
# echo 'Cloning depot_tools'
# git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$WORK_DIR/depot_tools:$PATH

# Get libmediasoupclient.
# cd $PROJECT_DIR/vl-mediasoup-client-ios/dependencies
# echo 'Cloning libmediasoupclient'
# rm -rf libmediasoupclient
# git clone https://github.com/VLprojects/libmediasoupclient.git

# Get WebRTC.
# cd $WORK_DIR
# echo 'Cloning WebRTC'
# mkdir -p webrtc-ios
# cd webrtc-ios
# fetch --nohooks webrtc_ios
# gclient sync
# cd src

# git checkout -b bh4577 refs/remotes/branch-heads/4577
# git checkout bh4577
# gclient sync

# А этот патч надо ?? Или сделать его в конце?
# cp $PATCHES_DIR/byte_order.h $WORK_DIR/webrtc-ios/src/rtc_base/

# Build WebRTC.
cd $WORK_DIR/webrtc-ios/src/
# rm -rf out_ios_libs
python tools_webrtc/ios/build_ios_libs.py --output-dir $BUILD_DIR/webrtc/ --extra-gn-args='rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true is_component_build=false rtc_enable_symbol_export=true use_xcode_clang=true rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'
# exit 0

# фактически набор флагов сейчас:
# target_os="ios"
# ios_enable_code_signing=false
# use_xcode_clang=true
# is_component_build=false
# rtc_include_tests=false
# is_debug=false
# target_environment="device"
# target_cpu="arm64"
# ios_deployment_target="12.0"
# rtc_libvpx_build_vp9=false
# enable_ios_bitcode=false
# use_goma=false
# rtc_enable_symbol_export=true
# rtc_include_builtin_audio_codecs=true
# is_component_build=false
# use_xcode_clang=true
# rtc_include_tests=false
# rtc_enable_protobuf=false
# use_rtti=true
# use_custom_libcxx=false
# enable_dsyms=true
# enable_stripping=true

# Надо попробовать дополнительные флаги передаваемые в build_ios_libs.py:
#	libcxx_abi_unstable=false
#	--ide=xcode
#	--arch 'device:arm64', 'simulator:arm64', 'simulator:x64'
#	--bitcode
#	--verbose
#	use_bitcode ??? enable_dsyms=true
#	libvpx_build_vp9
#	--purify
# symbol_level = 0 - более быстрая сборка, но без символов
# отключить ненужную хрень:
# 		enable_nacl = false
#		blink_symbol_level=0


## Не понятно, надо ли всё это на новом формате фреймворков (на bh4577)? Вроде не надо.
## 2 сент, 12:46 - Пробую добавить чтобы решить проблемы с недостающими символами
# cd $BUILD_DIR/webrtc
# ninja -C device/arm64_libs/ webrtc
# ninja -C simulator/arm64_libs/ webrtc
# ninja -C simulator/x64_libs/ webrtc

# exit 0

# Create WebRTC universal (fat) library.
# rm -rf WebRTC.xcframework
# lipo -create \
# 	simulator/arm64_libs/obj/libwebrtc.a \
# 	simulator/x64_libs/obj/libwebrtc.a \
# 	-output simulator/libwebrtc.a
# mkdir -p universal
# lipo -create \
# 	device/arm64_libs/obj/libwebrtc.a \
# 	simulator/x64_libs/obj/libwebrtc.a \
# 	-output universal/libwebrtc.a

# xcodebuild -create-xcframework \
# 	-library simulator/libwebrtc.a \
# 	-library device/arm64_libs/obj/libwebrtc.a \
# 	-output $OUTPUT_DIR/WebRTC.xcframework
# xcodebuild -create-xcframework \
# 	-library simulator/x64_libs/obj/libwebrtc.a \
# 	-library device/arm64_libs/obj/libwebrtc.a \
# 	-output $OUTPUT_DIR/WebRTC.xcframework


# Это надо, но тут бывают ошибки при перемещении папок, что папка не пуста...
# mv $WORK_DIR/webrtc-ios/src/* $WEBRTC_DIR
read -n 1

# if [ -d $OUTPUT_DIR/WebRTC.xcframework ]
# then
# 	echo 'Removing old WebRTC.xcframework'
# 	rm -rf $OUTPUT_DIR/WebRTC.xcframework
# fi

# cp -R $BUILD_DIR/webrtc/WebRTC.xcframework $OUTPUT_DIR/WebRTC.xcframework
# cp -R $WEBRTC_DIR/out_ios_libs/WebRTC.xcframework $OUTPUT_DIR/WebRTC.xcframework

# exit 0

# Build mediasoup-ios-client.
cd $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/

# TODO: установить CMAKE_BINARY_DIR на $BUILD_DIR

# возможно к этому моменту уже надо чтобы был накачен патч byte_order

cmake . -Bbuild_ios_arm64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/webrtc/device/arm64_libs/WebRTC.framework/WebRTC \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphone \
	-DIOS_ARCHS="arm64" \
	-DPLATFORM=OS64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
make -C build_ios_arm64

echo "Did build iphone arm64"

cmake . -Bbuild_sim_x86_64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/webrtc/simulator/x64_libs/WebRTC.framework/WebRTC \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphonesimulator \
	-DIOS_ARCHS="x86_64" \
	-DPLATFORM=SIMULATOR64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
make -C build_sim_x86_64

echo "Did build simulator x64"

cmake . -Bbuild_sim_arm64 \
	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
	-DLIBWEBRTC_BINARY_PATH=$BUILD_DIR/webrtc/simulator/arm64_libs/WebRTC.framework/WebRTC \
	-DMEDIASOUP_LOG_TRACE=ON \
	-DMEDIASOUP_LOG_DEV=ON \
	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
	-DIOS_SDK=iphonesimulator \
	-DIOS_ARCHS="arm64"\
	-DPLATFORM=SIMULATORARM64 \
	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
make -C build_sim_arm64

echo "Did build simulator arm64"

mkdir -p build_sim_fat

lipo -create \
	build_sim_x86_64/libmediasoupclient/libmediasoupclient.a \
	build_sim_arm64/libmediasoupclient/libmediasoupclient.a \
	-output build_sim_fat/libmediasoupclient.a

lipo -create \
	build_sim_x86_64/libmediasoupclient/libsdptransform/libsdptransform.a \
	build_sim_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
	-output build_sim_fat/libsdptransform.a
# todo: добавить -headers и -debug-symbols
xcodebuild -create-xcframework \
	-library build_ios_arm64/libmediasoupclient/libmediasoupclient.a \
	-library build_sim_fat/libmediasoupclient.a \
	-output $OUTPUT_DIR/mediasoupclient.xcframework

xcodebuild -create-xcframework \
	-library build_ios_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
	-library build_sim_fat/libsdptransform.a \
	-output $OUTPUT_DIR/sdptransform.xcframework

####cp $PATCHES_DIR/byte_order.h.orig $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/byte_order.h
####cp $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/byte_order.h $PATCHES_DIR/byte_order.h.orig
cp $PATCHES_DIR/byte_order.h $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/
open $PROJECT_DIR/vl-mediasoup-client-ios.xcodeproj
