//
//  Producer.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Producer.h"
#import "ProducerWrapper.h"

@implementation Producer : NSObject

-(instancetype)initWithNativeProducer:(NSValue *)nativeProducer {
    self = [super init];
    if (self) {
        self._nativeProducer = nativeProducer;
        
        webrtc::MediaStreamTrackInterface *nativeTrack = [ProducerWrapper getNativeTrack:self._nativeProducer];
        rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track(nativeTrack);

        RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
        
        self._nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:factory];
        free(factory);
    }
    
    return self;
}

-(NSString *)getId {
    return [ProducerWrapper getNativeId:self._nativeProducer];
}

-(bool)isClosed {
    return [ProducerWrapper isNativeClosed:self._nativeProducer];
}

-(NSString *)getKind {
    return [ProducerWrapper getNativeKind:self._nativeProducer];
}

-(RTCMediaStreamTrack *)getTrack {
    return self._nativeTrack;
}

-(bool)isPaused {
    return [ProducerWrapper isNativePaused:self._nativeProducer];
}

-(int)getMaxSpatialLayer {
    return [ProducerWrapper getNativeMaxSpatialLayer:self._nativeProducer];
}

-(NSString *)getAppData {
    return [ProducerWrapper getNativeAppData:self._nativeProducer];
}

-(NSString *)getRtpParameters {
    return [ProducerWrapper getNativeRtpParameters:self._nativeProducer];
}

-(void)resume {
    [ProducerWrapper nativeResume:self._nativeProducer];
}

-(void)pause {
    [ProducerWrapper nativePause:self._nativeProducer];
}

-(void)setMaxSpatialLayers:(int)layer {
    [ProducerWrapper setNativeMaxSpatialLayer:self._nativeProducer layer:layer];
}

-(void)replaceTrack:(RTCMediaStreamTrack *)track {
    [ProducerWrapper nativeReplaceTrack:self._nativeProducer track:track.hash];
    
    webrtc::MediaStreamTrackInterface *nativeTrack = [ProducerWrapper getNativeTrack:self._nativeProducer];
    rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> mediaTrack(nativeTrack);

    RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
    
    self._nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:mediaTrack factory:factory];
    free(factory);
}

-(NSString *)getStats {
    return [ProducerWrapper getNativeStats:self._nativeProducer];
}

-(void)close {
    [ProducerWrapper nativeClose:self._nativeProducer];
    [self._nativeProducer release];
    [self._nativeTrack release];
}

@end
