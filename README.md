# mediasoup-ios-client
Mediasoup 3 iOS Client

---

**This project supports both 64 bit iOS devices and 64 bit iOS Simulators**

# Getting Started

(Coming Soon)

# Documentation

(Coming Soon)

# Contributing

### Clone the repo and install submodules

```bash
git clone https://github.com/ethand91/mediasoup-ios-client.git
submodule init
submodule update
```

### Get the libraries

Due to the libwebrtc.a library being to big to upload to github, you will need to either:

* Follow the instructions located in the build directory
* Download the compiled libraries from an external provider

Previously built libraries can be found below:

* libmediasoupclient.a (arm64,x86_64): https://www.dropbox.com/s/8u1vvoutzcfqhhg/libmediasoupclient.a
* libsdptransform.a (arm64, x86_64): https://www.dropbox.com/s/jbk30y56dckjwj2/libsdptransform.a
* libwebrtc.a (arm64, x86_64): https://www.dropbox.com/s/sxnhub3p07hgtt5/libwebrtc.a
* WebRTC.framework (m74 branch): https://www.dropbox.com/s/qmqodqf4slsmvk5/WebRTC.framework.zip

The default library paths are as follows: (if you change the directory of the libraries make sure to update the relevant search paths):
* libmediasoupclient.a/libsdptransform.a - dependencies/libmediasoupclient/lib
* libwebrtc.a - dependencies/webrtc/src/out_ios_libs/universal
* WebRTC.framework - dependencies/webrtc/src/out_ios_libs/
 
