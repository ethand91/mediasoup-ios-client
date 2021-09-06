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
export OUTPUT_DIR=$(pwd)/bin
echo "OUTPUT_DIR = $OUTPUT_DIR"
export PATCHES_DIR=$(pwd)/patches
echo "PATCHES_DIR = $PATCHES_DIR"
export WEBRTC_DIR=$PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src
echo "WEBRTC_DIR = $WEBRTC_DIR"


echo -e "Clear working directory and refetch dependencies? (y|N): \c"
read -n 1 INPUT_STRING
echo ""
case $INPUT_STRING in
	y|Y)
		if [ -d $OUTPUT_DIR ]
		then
			echo 'Removing old output dir'
			rm -rf $OUTPUT_DIR
		fi
		mkdir -p $OUTPUT_DIR
		echo 'OUTPUT_DIR created'

		if [ -d $WORK_DIR ]
		then
			echo 'Removing old work dir'
			rm -rf $WORK_DIR
		fi
		mkdir -p $WORK_DIR
		echo 'WORK_DIR created'

		if [ -d $BUILD_DIR ]
		then
			echo 'Removing old build dir'
			rm -rf $BUILD_DIR
		fi
		mkdir -p $BUILD_DIR
		echo 'BUILD_DIR created'

		echo 'Cloning libmediasoupclient'
		cd $PROJECT_DIR/vl-mediasoup-client-ios/dependencies
		rm -rf libmediasoupclient
		git clone https://github.com/VLprojects/libmediasoupclient.git

		echo 'Cloning depot_tools'
		cd $WORK_DIR
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
		export PATH=$WORK_DIR/depot_tools:$PATH

		echo 'Cloning WebRTC'
		mkdir -p $WORK_DIR/webrtc-ios
		cd $WORK_DIR/webrtc-ios
		fetch --nohooks webrtc_ios
		gclient sync
		cd $WORK_DIR/webrtc-ios/src
		git checkout -b m92 refs/remotes/branch-heads/4515
		gclient sync
		# Apply patches to make it buildable with Xcode.
		# patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/BUILD.patch
		;;
	*)
		export PATH=$WORK_DIR/depot_tools:$PATH
		# cd $WORK_DIR/webrtc-ios/src
		# git checkout m92
		# gclient sync
		;;
esac

# cp $PATCHES_DIR/byte_order.h $WORK_DIR/webrtc-ios/src/rtc_base/byte_order.h
# cp $PATCHES_DIR/byte_order.orig.h $WORK_DIR/webrtc-ios/src/rtc_base/byte_order.h

echo 'Building WebRTC'
cd $WORK_DIR/webrtc-ios/src
rm -rf out_ios_libs
python tools_webrtc/ios/build_ios_libs.py --extra-gn-args='is_component_build=false use_xcode_clang=true rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'

# Create WebRTC universal (fat) library.
cd $WORK_DIR/webrtc-ios/src/out_ios_libs
ninja -C arm64_libs/ webrtc
ninja -C x64_libs/ webrtc
mkdir -p universal
lipo -create \
	arm64_libs/obj/libwebrtc.a \
	x64_libs/obj/libwebrtc.a \
	-output universal/libwebrtc.a

echo -e "Move webrtc directory..."
read -n 1 INPUT_STRING
# mv $WORK_DIR/webrtc-ios/src/* $WEBRTC_DIR

rm -rf $OUTPUT_DIR/WebRTC.framework
cp -R $WEBRTC_DIR/out_ios_libs/WebRTC.framework $OUTPUT_DIR/WebRTC.framework

# Build mediasoup-ios-client.
cd $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/

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

# TODO: перенести .a файлики в output_dir

cp $PATCHES_DIR/byte_order.h $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/
open $PROJECT_DIR/vl-mediasoup-client-ios.xcodeproj
