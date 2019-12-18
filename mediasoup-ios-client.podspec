#
#  Be sure to run `pod spec lint mediasoup-client-ios.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "mediasoup-ios-client"
  spec.version      = "0.0.3"
  spec.summary      = "Mediasoup 3 iOS Client"

  spec.description  = <<-DESC
    iOS implementation of libmediasoupclient
                   DESC

  spec.homepage     = "https://github.com/ethand91/mediasoup-ios-client"
  spec.license      = "MIT"
  spec.author       = { "ethand91" => "ethan@maru.jp" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/ethand91/mediasoup-ios-client.git", :tag => "0.0.3", :submodules => true }

  # Get libraries that are too big to push to github
  spec.prepare_command = <<-CMD
    mkdir -p mediasoup-ios-client/dependencies/webrtc/src/out_ios_libs/universal

    wget -P mediasoup-ios-client/dependencies/webrtc/src/out_ios_libs/universal/libwebrtc.a https://www.dropbox.com/s/sxnhub3p07hgtt5/libwebrtc.a
  CMD

	# Disable arc
  spec.requires_arc = false
	# Include C++ library
  spec.libraries = "c++"
	# Set the xcode variables for the pod target
  spec.pod_target_xcconfig = {
    "HEADER_SEARCH_PATHS" => '"$(inherited)" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/dependencies/webrtc/src" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/include" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/include/wrapper" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/dependencies/libmediasoupclient/include" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/dependencies/libmediasoupclient/deps/libsdptransform/include" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/webrtc" "${PODS_ROOT}/Headers/Public/mediasoup-ios-client/dependencies/webrtc/src/third_party/abseil-cpp"',
    "USE_HEADERMAP" => "NO",
    "ALWAYS_SEARCH_USER_PATHS" => "NO",
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
    "CLANG_CXX_LIBRARY" => "libc++",
    "OTHER_CPLUSPLUSFLAGS" => '"-stdlib=libc++" "-Wall" "-Wextra" "-Wpedantic"',
    "VALID_ARCHS" => "$(ARCHS_STANDARD_64_BIT)",
    "OTHER_LD_FLAGS" => "-all_load"
  }

	# Include frameworks needed for WebRTC
  spec.frameworks = "AVFoundation", "AudioToolbox", "CoreAudio", "CoreMedia", "CoreVideo", "UIKit"

  spec.preserve_paths = "mediasoup-client-ios/dependencies/libmediasoupclient/include/*.hpp",
    "mediasoup-client-ios/dependencies/libmediasoupclient/include/sdp/*.hpp",
    "mediasoup-client-ios/dependencies/libmediasoupclient/deps/libsdptransform/include/*.hpp",
    "mediasoup-client-ios/dependencies/libmediasoupclient/LICENSE",
    "mediasoup-client-ios/dependencies/webrtc/src/out_ios_libs/*.a",
    "mediasoup-client-ios/dependencies/libmediasoupclient/lib/*.a",
    "mediasoup-client-ios/dependencies/webrtc/src/api/**/*.h",
    "mediasoup-client-ios/dependencies/webrtc/src/third_party/abseil-cpp/**/*.h"

	# Do not include any unneeded files
  spec.exclude_files = "mediasoup-client-ios/dependencies/libmediasoupclient/test",
    "mediasoup-client-ios/dependencies/libmediasoupclient/deps/libsdptransform/test",
    "mediasoup-client-ios/dependencies/webrtc/src/audio",
    "mediasoup-client-ios/dependencies/webrtc/src/build_override",
    "mediasoup-client-ios/dependencies/webrtc/src/call/**/*.{m,mm,cc}",
    "mediasoup-client-ios/dependencies/webrtc/src/codereview.settings",
    "mediasoup-client-ios/dependencies/webrtc/src/common_audio",
    "mediasoup-client-ios/dependencies/webrtc/src/common_video",
    "mediasoup-client-ios/dependencies/webrtc/src/data",
    "mediasoup-client-ios/dependencies/webrtc/src/examples",
    "mediasoup-client-ios/dependencies/webrtc/src/logging/**/*.{m,mm,cc}",
    "mediasoup-client-ios/dependencies/webrtc/src/media/**.*.{m,mm,cc}",
    "mediasoup-client-ios/dependencies/webrtc/src/pc",
    "mediasoup-client-ios/dependencies/webrtc/src/pylintrc",
    "mediasoup-client-ios/dependencies/webrtc/src/resources",
    "mediasoup-client-ios/dependencies/webrtc/src/rtc_tools",
    "mediasoup-client-ios/dependencies/webrtc/src/sdk",
    "mediasoup-client-ios/dependencies/webrtc/src/stats",
    "mediasoup-client-ios/dependencies/webrtc/src/style-guide",
    "mediasoup-client-ios/dependencies/webrtc/src/test",
    "mediasoup-client-ios/dependencies/webrtc/src/tools_webrtc",
    "mediasoup-client-ios/dependencies/webrtc/src/video",
    "mediasoup-client-ios/dependencies/webrtc/src/api/test",
    "mediasoup-client-ios/dependencies/webrtc/src/modules/**/*.{m,mm,cc}",
    "mediasoup-client-ios/dependencies/webrtc/src/rtc_base/**/*.{m,mm,cc}",
    "mediasoup-client-ios/dependencies/webrtc/src/p2p/**/*.{m,mm,cc}",
    "mediasoup-client-ios/dependencies/webrtc/src/third_party/abseil-cpp/absl/**/*.cc"

	# Include WebRTC Framework
  spec.vendored_frameworks = "mediasoup-client-ios/dependencies/webrtc/src/out_ios_libs/WebRTC.framework"
	# Include needed static libraries
  spec.vendored_libraries = "mediasoup-client-ios/dependencies/libmediasoupclient/lib/libmediasoupclient.a",
    "mediasoup-client-ios/dependencies/libmediasoupclient/lib/libsdptransform.a",

  spec.libraries = "mediasoupclient", "sdptransform"

  spec.header_mappings_dir = "mediasoup-client-ios"

  spec.source_files  = "mediasoup-client-ios/**/*.{h,hpp,m,mm}"
end
