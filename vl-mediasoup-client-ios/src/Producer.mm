//
//  Producer.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactory.h>
#import "peerconnection/RTCMediaStreamTrack+Private.h"
#import "Producer.h"
#import "ProducerWrapper.h"

@interface Producer ()
@property(nonatomic, strong) NSValue* nativeProducer;
@property(nonatomic, strong) RTCMediaStreamTrack *nativeTrack;
@property(nonatomic, strong) RTCPeerConnectionFactory *factory;
@end

@implementation Producer : NSObject

-(instancetype)initWithNativeProducer:(NSValue *)nativeProducer pcFactory:(RTCPeerConnectionFactory *)pcFactory {
    self = [super init];
    if (self) {
        self.nativeProducer = nativeProducer;
        
        webrtc::MediaStreamTrackInterface *nativeTrack = [ProducerWrapper getNativeTrack:self.nativeProducer];
        rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track(nativeTrack);

        self.factory = pcFactory;
        self.nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:pcFactory];
    }
    
    return self;
}

-(void)dealloc {
    if (self.nativeProducer != nil && ![ProducerWrapper isNativeClosed:self.nativeProducer]) {
        [ProducerWrapper nativeClose:self.nativeProducer];
    }
    [ProducerWrapper nativeFree:self.nativeProducer];
}

-(NSString *)getId {
    return [ProducerWrapper getNativeId:self.nativeProducer];
}

-(bool)isClosed {
    return [ProducerWrapper isNativeClosed:self.nativeProducer];
}

-(NSString *)getKind {
    return [ProducerWrapper getNativeKind:self.nativeProducer];
}

-(RTCMediaStreamTrack *)getTrack {
    return self.nativeTrack;
}

-(bool)isPaused {
    return [ProducerWrapper isNativePaused:self.nativeProducer];
}

-(int)getMaxSpatialLayer {
    return [ProducerWrapper getNativeMaxSpatialLayer:self.nativeProducer];
}

-(NSString *)getAppData {
    return [ProducerWrapper getNativeAppData:self.nativeProducer];
}

-(NSString *)getRtpParameters {
    return [ProducerWrapper getNativeRtpParameters:self.nativeProducer];
}

-(void)resume {
    [ProducerWrapper nativeResume:self.nativeProducer];
}

-(void)pause {
    [ProducerWrapper nativePause:self.nativeProducer];
}

-(void)setMaxSpatialLayers:(int)layer {
    [ProducerWrapper setNativeMaxSpatialLayer:self.nativeProducer layer:layer];
}

-(void)replaceTrack:(RTCMediaStreamTrack *)track {
    [ProducerWrapper nativeReplaceTrack:self.nativeProducer track:track.hash];
    
    webrtc::MediaStreamTrackInterface *nativeTrack = [ProducerWrapper getNativeTrack:self.nativeProducer];
    rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> mediaTrack(nativeTrack);

    self.nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:mediaTrack factory:self.factory];
}

-(NSString *)getStats {
    return [ProducerWrapper getNativeStats:self.nativeProducer];
}

-(void)close {
    [ProducerWrapper nativeClose:self.nativeProducer];
}

@end
