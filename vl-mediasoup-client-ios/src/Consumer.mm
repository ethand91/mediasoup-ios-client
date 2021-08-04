//
//  Consumer.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactory.h>

#import "Consumer.h"
#import "ConsumerWrapper.h"

@interface Consumer ()
@property(nonatomic, retain) RTCPeerConnectionFactory *factory;
@end

@implementation Consumer : NSObject

-(instancetype)initWithNativeConsumer:(NSValue *)nativeConsumer {
    self = [super init];
    if (self) {
        __nativeConsumer = [nativeConsumer retain];
        
        webrtc::MediaStreamTrackInterface *nativeTrack = [ConsumerWrapper getNativeTrack:self._nativeConsumer];
        rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track(nativeTrack);

        _factory = [[RTCPeerConnectionFactory alloc] init];
        __nativeTrack = [[RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:_factory] retain];
    }
    
    return self;
}

- (void)dealloc {
    if (__nativeConsumer != nil && ![ConsumerWrapper isNativeClosed:__nativeConsumer]) {
        [ConsumerWrapper nativeClose:__nativeConsumer];
    }
    [__nativeConsumer release];
    [__nativeTrack release];
    [_factory release];
    [super dealloc];
}

-(NSString *)getId {
    return [ConsumerWrapper getNativeId:self._nativeConsumer];
}

-(NSString *)getProducerId {
    return [ConsumerWrapper getNativeProducerId:self._nativeConsumer];
}

-(bool)isClosed {
    return [ConsumerWrapper isNativeClosed:self._nativeConsumer];
}

-(bool)isPaused {
    return [ConsumerWrapper isNativePaused:self._nativeConsumer];
}

-(NSString *)getKind {
    return [ConsumerWrapper getNativeKind:self._nativeConsumer];
}

-(RTCMediaStreamTrack *)getTrack {
    return self._nativeTrack;
}

-(NSString *)getRtpParameters {
    return [ConsumerWrapper getNativeRtpParameters:self._nativeConsumer];
}

-(NSString *)getAppData {
    return [ConsumerWrapper getNativeAppData:self._nativeConsumer];
}

-(void)resume {
    [ConsumerWrapper nativeResume:self._nativeConsumer];
}

-(void)pause {
    [ConsumerWrapper nativePause:self._nativeConsumer];
}

-(NSString *)getStats {
    return [ConsumerWrapper getNativeStats:self._nativeConsumer];
}

-(void)close {
    [ConsumerWrapper nativeClose:self._nativeConsumer];
}

@end
