Pod::Spec.new do |spec|
  spec.name         = "vl_mediasoup_client_ios"
  spec.version      = "1.5.5"
  spec.summary      = "Mediasoup 3 iOS Client"

  spec.description  = <<-DESC
    iOS implementation of libmediasoupclient
                   DESC

  spec.homepage     = "https://github.com/VLprojects/mediasoup-ios-client"
  spec.license      = "MIT"
  spec.author       = { "Alexander Gorbunov" => "gorbunov.a@vlprojects.pro" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/VLprojects/mediasoup-ios-client.git", :tag => "m92.1" }
  spec.module_name = "vl_mediasoup_client_ios"

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

  spec.vendored_frameworks = "bin/vl_mediasoup_client_ios.framework", "bin/WebRTC.framework"

  spec.module_map = "vl_mediasoup-client-ios/vl_mediasoup_client_ios.modulemap"
end

