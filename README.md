# mediasoup-ios-client

Objective-C wrapper library for libmediasoupclient for building mediasoup iOS based applications.

**This project supports both 64 bit iOS devices and 64 bit iOS Simulators**

## Website and Documentation

* [mediasoup.org][mediasoup-website]

## Support Forum

* [mediasoup.discourse.group][mediasoup-discourse]

---

## Getting Started

### Download the required frameworks

* mediasoup-ios-client Framework: https://www.dropbox.com/s/7mz09tza4xbrwta/mediasoup_client_ios.framework.zip
* WebRTC.framework: https://www.dropbox.com/s/qmqodqf4slsmvk5/WebRTC.framework.zip

Extract the frameworks and place them in your projects [Frameworks] folder.
You may need to configure your projects search paths

**Swift users will need to implement a Objective-C Bridging Header**

## Documentation

(Coming Soon)

## Usage Example

```objective-c
#import "mediasoup_client_ios/Mediasoupclient.h

// Initialize the underlaying libmediasoupclient
[Mediasoupclient initializePC];

// Create a Device
Device *device = [[Device alloc] init];

// Communicate with our server app to retrieve router RTP capabilities
NSString *routerRtpCapabilities = [mySignalling request:@"getRouterRtpCapabilities"];

// Load the device with the routerRtpCapabilities
[device load:routerRtpCapabilities];

// Check whether we can produce video to the router
if ![device canProduce:@"video"] {
 NSLog(@"cannot produce video");
 // Abort next steps
}

// Create a transport in the server for sending our media through it
NSDictionary *transportData = [mySignalling request:@"createTransport"];

// Object to handle SendTransportListener events
@interface SendTransportHandler: NSObject<SendTransportListener>
@property (nonatomic) id delegate;
@end

@implementation SendTransportHandler
-(void)onConnect:(Transport *)transport dtlsParameters:(NSString *)dtlsParameters {
 // Here we communicate out local parameters to our remote transport
 [mySignalling request:@"transport-connect" transportId:[transport getId] dtlsParameters:dtlsParameters];
}

-(void)onConnectionStateChange:(Transport *)transport connectionState:(NSString *)connectionState {
 NSLog(@"sendTransport::onConnectionStateChange newState = %@", connectionState);
}

-(NSString *)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
 // Here we must communicate our local parameters to our remote transport
 NSString *id = [mySignalling request:@"produce" transportId:[transport getId] kind:kind rtpParameters:rtpParameters appData:appData];
 
 return id;
}
@end

SendTransport *sendTransport = [device createSendTransport:sendTransportHandler.delegate id:transportData["id"] iceParameters:transportData["iceParameters"] iceCandidates:transportData["iceCandidates"] dtlsParameters:transportData["dtlsParameters"]];

// Get the device camera
NSArray *devices = [AVCaptureDevice devicesWithMediaType: AVMediaTypeVideo];

// Start capturing it
RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
RTCCameraVideoCapturer *videoCapturer = [[RTCCameraVideoCapturer alloc] init];
[videoCapturer startCaptureWithDevice:devices[0] format:[devices[0] activeFormat] fps:30];
RTCVideoSource *videoSource = [factory videoSource];
[videoSource adaptOutputFormatToWidth:640 height:480 fps:30];

RTCVideoTrack *videoTrack = [factory videoTrackWithSource:videoSource trackId:@"trackId"];

// Handler to handle producer events
@interface ProducerHandler : NSObject<ProducerListener>
@property (nonatomic) id delegate;
@end

@implementation ProducerHandler
-(void)onTransportClose:(Producer *)producer {
 NSLog(@"Producer::onTransportClose");
}
@end

// Produce out camera video
Producer *videoProducer = [sendTransport produce:producerHandler.delegate track:videoTrack encodings:nil codecOptions:nil];
```

## Contributing

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
 
