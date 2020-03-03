Pod::Spec.new do |spec|
  spec.name = "mediasoup_webrtc"
  spec.version = "1.0.0"
  spec.summary = "WebRTC library for mediasoup iOS"

  spec.description = <<-DESC
    WebRTC library used by mediasoup iOS library
  DESC

  spec.homepage = "https://github.com/ethand91/webrtc-mac-src"
  spec.license = "MIT"
  spec.author = { "ethand91" => "ethan@maru.jp" }
  spec.platform = :ios, "9.0"
  spec.source = { :http => "https://github.com/ethand91/webrtc-mac-src/out_ios_libs/WebRTC.framework.zip" }

  # Libraries needed for WebRTC
  spec.frameworks = "AVFoundation", "AudioToolbox", "CoreAudio", "CodeMedia", "CoreVideo"
end
