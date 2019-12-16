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

@implementation Consumer : NSObject

-(instancetype)initWithNativeConsumer:(NSValue *)nativeConsumer {
    self = [super init];
    if (self) {
        self._nativeConsumer = nativeConsumer;
        
        webrtc::MediaStreamTrackInterface *nativeTrack = [ConsumerWrapper getNativeTrack:self._nativeConsumer];
        rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track(nativeTrack);

        RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
        
        self._nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:factory];
        free(factory);
    }
    
    return self;
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
