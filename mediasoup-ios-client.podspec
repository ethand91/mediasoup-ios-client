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

	# Disable arc
  spec.requires_arc = false
	# Set the xcode variables for the pod target
  spec.pod_target_xcconfig = {
    "ENABLE_BITCODE" => "NO",
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

  spec.ios.vendored_frameworks = "build/mediasoup_client_ios.framework"
end
