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
		git checkout -b bh4577 refs/remotes/branch-heads/4577
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

echo 'Building WebRTC'
cd $WORK_DIR/webrtc-ios/src
rm -rf $OUTPUT_DIR/WebRTC.xcframework
python tools_webrtc/ios/build_ios_libs.py --output-dir $OUTPUT_DIR/ --extra-gn-args='rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true is_component_build=false rtc_enable_symbol_export=true use_xcode_clang=true rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'

# Create WebRTC framework.


echo -e "Move webrtc directory..."
read -n 1 INPUT_STRING
# mv $WORK_DIR/webrtc-ios/src/* $WEBRTC_DIR


cp -R $WEBRTC_DIR/out_ios_libs/WebRTC.framework $OUTPUT_DIR/WebRTC.framework

# Build mediasoup-ios-client.
cd $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/

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

cp $PATCHES_DIR/byte_order.h $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/
open $PROJECT_DIR/vl-mediasoup-client-ios.xcodeproj
