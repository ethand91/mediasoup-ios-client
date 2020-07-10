# mediasoup-ios-client

Objective-C wrapper library for libmediasoupclient for building mediasoup iOS based applications.

**This project supports both 64 bit iOS devices and 64 bit iOS Simulators**

![Cocoapods version](https://img.shields.io/cocoapods/v/mediasoup_ios_client?color=green&label=Cocoapods&logo=Cocoapods)
![License](https://img.shields.io/github/license/ethand91/mediasoup-ios-client)

## Website and Documentation

* [mediasoup.org](https://mediasoup.org/)

## Support Forum

* [mediasoup.discourse.group](https://mediasoup.discourse.group/)

---

## Getting Started

### Cocoapods

Add the below into your Podfile:

```ruby
use_frameworks!

target "target" do
  pod "mediasoup_ios_client"
end
```

**You will need to set enable bitcode to false**

Due to the size of the WebRTC.framework with bitcode, it cannot be uploaded to Github.

**Swift users will need to implement a Objective-C Bridging Header**

Bridging header sample:

https://github.com/ethand91/mediasoup-ios-client-sample/blob/master/mediasoup-ios-cient-sample/mediasoup-ios-cient-sample-Bridging-Header.h

## Documentation

#### API

https://github.com/ethand91/mediasoup-ios-client/blob/master/documentation/Api.md

#### INSTALLATION (Only needed for development, not needed if you only intent to use the project)

https://github.com/ethand91/mediasoup-ios-client/blob/master/documentation/Installation.md

## Usage Example

```objective-c
#import "mediasoup_client_ios/Mediasoupclient.h

// Initialize the underlaying libmediasoupclient
[Mediasoupclient initializePC];

// Create a Device
MediasoupDevice *device = [[MediasoupDevice alloc] init];

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

-(NSString *)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData callback:(void(^)(NSString *))callback {
 // Here we must communicate our local parameters to our remote transport
 NSString *id = [mySignalling request:@"produce" transportId:[transport getId] kind:kind rtpParameters:rtpParameters appData:appData];
 
 callback(id);
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

Due to the size of the WebRTC static library it cannot be uploaded to Github, therefore you will need to follow the instructions in the build folder and build it yourself. (This step is only needed for development, not for library usage)

```bash
git clone https://github.com/ethand91/mediasoup-ios-client.git
git submodule init
git submodule update
```
 
