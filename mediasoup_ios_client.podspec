Pod::Spec.new do |spec|
  spec.name         = "mediasoup_ios_client"
  spec.version      = "1.2.1"
  spec.summary      = "Mediasoup 3 iOS Client"

  spec.description  = <<-DESC
    iOS implementation of libmediasoupclient
                   DESC

  spec.homepage     = "https://github.com/ethand91/mediasoup-ios-client"
  spec.license      = "MIT"
  spec.author       = { "ethand91" => "ethan@maru.jp" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/ethand91/mediasoup-ios-client.git", :submodules => true, :tag => "1.2.1" }
  spec.module_name = "mediasoup"

	# Disable arc
  spec.requires_arc = false
	# Set the xcode variables for the pod target
  spec.pod_target_xcconfig = {
    "USE_HEADERMAP" => "NO",
    "ALWAYS_SEARCH_USER_PATHS" => "NO",
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
    "CLANG_CXX_LIBRARY" => "libc++",
    "OTHER_CPLUSPLUSFLAGS" => '"-stdlib=libc++" "-Wall" "-Wextra" "-Wpedantic"',
    "VALID_ARCHS" => "$(ARCHS_STANDARD_64_BIT)",
    "OTHER_LD_FLAGS" => "-all_load",
  }

	# Include frameworks needed for WebRTC
  spec.frameworks = "AVFoundation", "AudioToolbox", "CoreAudio", "CoreMedia", "CoreVideo"

  spec.vendored_frameworks = "build/mediasoup_client_ios.framework", "mediasoup-client-ios/dependencies/webrtc/src/out_ios_libs/WebRTC.framework"

  spec.module_map = "mediasoup-client-ios/mediasoup_ios_client.modulemap"
end
