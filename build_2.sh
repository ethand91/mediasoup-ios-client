#!/bin/bash

# Stop script on errors.
set -e

# Define working directories.
export PROJECT_DIR=$(pwd)
echo "PROJECT_DIR = $PROJECT_DIR"
export WORK_DIR=$PROJECT_DIR/vl-mediasoup-client-ios/dependencies
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
		mkdir -p $WORK_DIR/webrtc
		cd $WORK_DIR/webrtc
		fetch --nohooks webrtc_ios
		gclient sync
		cd $WORK_DIR/webrtc/src
		# git checkout -b bh4577 refs/remotes/branch-heads/4577
		git checkout -b m92 refs/remotes/branch-heads/4515
		gclient sync
		# Apply patches to make it buildable with Xcode.
		# patch -b -p0 -d $WORK_DIR < $PATCHES_DIR/BUILD.patch
		;;
	*)
		export PATH=$WORK_DIR/depot_tools:$PATH
		cd $WORK_DIR/webrtc/src
		
		# git checkout -b m92 refs/remotes/branch-heads/4515
		# git checkout m92
		# git checkout -b m93 refs/remotes/branch-heads/4577
		# git checkout m93
		# gclient sync

		git restore rtc_base/byte_order.h
		;;
esac

echo 'Building WebRTC'
cd $WORK_DIR/webrtc/src
# rm -rf $OUTPUT_DIR/WebRTC.xcframework
# python tools_webrtc/ios/build_ios_libs.py --extra-gn-args='rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true is_component_build=false rtc_enable_symbol_export=true use_xcode_clang=true rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'
# rtc_enable_objc_symbol_export=true
# --output-dir $BUILD_DIR/

# gn gen out_ios_libs/device/arm64_libs --args='target_os="ios" target_cpu="arm64" ios_deployment_target="10.0" ios_enable_code_signing=false use_xcode_clang=true is_component_build=false rtc_include_tests=false is_debug=false rtc_libvpx_build_vp9=false enable_ios_bitcode=false use_goma=false rtc_enable_symbol_export=true rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false enable_dsyms=true enable_stripping=true treat_warnings_as_errors=false'
# gn gen out_ios_libs/simulator/x64_libs --args='target_os="ios" target_cpu="x64" ios_deployment_target="10.0" ios_enable_code_signing=false use_xcode_clang=true is_component_build=false rtc_include_tests=false is_debug=false rtc_libvpx_build_vp9=false enable_ios_bitcode=false use_goma=false rtc_enable_symbol_export=true rtc_include_builtin_audio_codecs=true rtc_include_builtin_video_codecs=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false enable_dsyms=true enable_stripping=true treat_warnings_as_errors=false'

#cd $WORK_DIR/webrtc/src/out_ios_libs
# ninja -C device/arm64_libs/ webrtc
# ninja -C simulator/x64_libs/ webrtc

# 3:20 - 3:32 собирал это
# ninja -C device/arm64_libs sdk:framework_objc
# ninja -C simulator/x64_libs sdk:framework_objc

cd $WORK_DIR/webrtc/src/out_ios_libs

# 9:56 собирал это поверх, чтобы получить .a файлы вебртс
ninja -C device/arm64_libs webrtc
ninja -C simulator/x64_libs webrtc
# ninja -C simulator/arm64_libs webrtc

# xcodebuild -create-xcframework \
# 	-framework device/arm64_libs/WebRTC.framework \
# 	-output $OUTPUT_DIR/WebRTC.xcframework
	# -framework out/ios_x64/WebRTC.framework \
	# -framework out/mac_x64/WebRTC.framework \

mkdir -p universal
lipo -create \
	device/arm64_libs/obj/libwebrtc.a \
	simulator/x64_libs/obj/libwebrtc.a \
	-output universal/libwebrtc.a

# lipo -create \
# 	simulator/arm64_libs/obj/libwebrtc.a \
# 	simulator/x64_libs/obj/libwebrtc.a \
# 	-output simulator/libwebrtc.a

# xcodebuild -create-xcframework \
# 	-library device/arm64_libs/obj/libwebrtc.a \
# 	-library simulator/libwebrtc.a \
# 	-output $OUTPUT_DIR/WebRTC.xcframework


# rm -rf out_ios_libs
# python tools_webrtc/ios/build_ios_libs.py --extra-gn-args='is_component_build=false use_xcode_clang=true rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'

# # Create WebRTC universal (fat) library.
# cd $WORK_DIR/webrtc/src/out_ios_libs
# ninja -C arm64_libs/ webrtc
# ninja -C x64_libs/ webrtc
# mkdir -p universal
# lipo -create \
# 	arm64_libs/obj/libwebrtc.a \
# 	x64_libs/obj/libwebrtc.a \
# 	-output universal/libwebrtc.a

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
	-output $OUTPUT_DIR/libmediasoupclient.a

lipo -create \
	build_ios_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
	build_sim_x86_64/libmediasoupclient/libsdptransform/libsdptransform.a \
	-output $OUTPUT_DIR/libsdptransform.a

cp $PATCHES_DIR/byte_order.h $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/
open $PROJECT_DIR/vl-mediasoup-client-ios.xcodeproj



# # Build mediasoup-ios-client.
# cd $WORK_DIR

# cmake . -Bbuild_ios_arm64 \
# 	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
# 	-DLIBWEBRTC_BINARY_PATH=$WORK_DIR/webrtc/src/out_ios_libs/device/arm64_libs/obj/libwebrtc.a \
# 	-DMEDIASOUP_LOG_TRACE=ON \
# 	-DMEDIASOUP_LOG_DEV=ON \
# 	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
# 	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
# 	-DIOS_SDK=iphone \
# 	-DIOS_ARCHS="arm64" \
# 	-DPLATFORM=OS64 \
# 	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
# make -C build_ios_arm64

# cmake . -Bbuild_sim_x86_64 \
# 	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
# 	-DLIBWEBRTC_BINARY_PATH=$WORK_DIR/webrtc/src/out_ios_libs/simulator/x64_libs/obj/libwebrtc.a \
# 	-DMEDIASOUP_LOG_TRACE=ON \
# 	-DMEDIASOUP_LOG_DEV=ON \
# 	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
# 	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
# 	-DIOS_SDK=iphonesimulator \
# 	-DIOS_ARCHS="x86_64" \
# 	-DPLATFORM=SIMULATOR64 \
# 	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
# make -C build_sim_x86_64

# # cmake . -Bbuild_sim_arm64 \
# # 	-DLIBWEBRTC_INCLUDE_PATH=$WEBRTC_DIR \
# # 	-DLIBWEBRTC_BINARY_PATH=$WORK_DIR/webrtc/src/out_ios_libs/simulator/arm64_libs/obj/libwebrtc.a \
# # 	-DMEDIASOUP_LOG_TRACE=ON \
# # 	-DMEDIASOUP_LOG_DEV=ON \
# # 	-DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
# # 	-DLIBSDPTRANSFORM_BUILD_TESTS=OFF \
# # 	-DIOS_SDK=iphonesimulator \
# # 	-DIOS_ARCHS="arm64"\
# # 	-DPLATFORM=SIMULATORARM64 \
# # 	-DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
# # make -C build_sim_arm64

# mkdir -p libmediasoupclient/lib
# lipo -create \
# 	build_ios_arm64/libmediasoupclient/libmediasoupclient.a \
# 	build_sim_x86_64/libmediasoupclient/libmediasoupclient.a \
# 	-output libmediasoupclient/lib/libmediasoupclient.a

# lipo -create \
# 	build_ios_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
# 	build_sim_x86_64/libmediasoupclient/libsdptransform/libsdptransform.a \
# 	-output libmediasoupclient/lib/libsdptransform.a


# # mkdir -p build_sim_fat
# # lipo -create \
# # 	build_sim_x86_64/libmediasoupclient/libmediasoupclient.a \
# # 	build_sim_arm64/libmediasoupclient/libmediasoupclient.a \
# # 	-output build_sim_fat/libmediasoupclient.a
# # lipo -create \
# # 	build_sim_x86_64/libmediasoupclient/libsdptransform/libsdptransform.a \
# # 	build_sim_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
# # 	-output build_sim_fat/libsdptransform.a
# # 
# # todo: добавить -headers и -debug-symbols
# # xcodebuild -create-xcframework \
# # 	-library build_ios_arm64/libmediasoupclient/libmediasoupclient.a \
# # 	-library build_sim_fat/libmediasoupclient.a \
# # 	-output $OUTPUT_DIR/mediasoupclient.xcframework
# # xcodebuild -create-xcframework \
# # 	-library build_ios_arm64/libmediasoupclient/libsdptransform/libsdptransform.a \
# # 	-library build_sim_fat/libsdptransform.a \
# # 	-output $OUTPUT_DIR/sdptransform.xcframework

# cp $PATCHES_DIR/byte_order.h $PROJECT_DIR/vl-mediasoup-client-ios/dependencies/webrtc/src/rtc_base/
# open $PROJECT_DIR/vl-mediasoup-client-ios.xcodeproj
