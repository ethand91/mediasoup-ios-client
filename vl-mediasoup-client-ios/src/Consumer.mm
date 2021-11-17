//
//  Consumer.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactory.h>
#import "peerconnection/RTCMediaStreamTrack+Private.h"
#import "Consumer.h"
#import "ConsumerWrapper.h"


@interface Consumer ()
@property(nonatomic, strong) NSValue* nativeConsumer;
@property(nonatomic, strong) RTCMediaStreamTrack *nativeTrack;
@property(nonatomic, strong) RTCPeerConnectionFactory *factory;
@end


@implementation Consumer : NSObject

-(instancetype)initWithNativeConsumer:(NSValue *)nativeConsumer {
    self = [super init];
    if (self) {
        self.nativeConsumer = nativeConsumer;
        
        webrtc::MediaStreamTrackInterface *nativeTrack = [ConsumerWrapper getNativeTrack:self.nativeConsumer];
        rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track(nativeTrack);

        self.factory = [[RTCPeerConnectionFactory alloc] init];
        self.nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:self.factory];
    }
    
    return self;
}

- (void)dealloc {
    if (self.nativeConsumer != nil && ![ConsumerWrapper isNativeClosed:self.nativeConsumer]) {
        [ConsumerWrapper nativeClose:self.nativeConsumer];
    }
    [ConsumerWrapper nativeFree:self.nativeConsumer];
}

-(NSString *)getId {
    return [ConsumerWrapper getNativeId:self.nativeConsumer];
}

-(NSString *)getProducerId {
    return [ConsumerWrapper getNativeProducerId:self.nativeConsumer];
}

-(bool)isClosed {
    return [ConsumerWrapper isNativeClosed:self.nativeConsumer];
}

-(bool)isPaused {
    return [ConsumerWrapper isNativePaused:self.nativeConsumer];
}

-(NSString *)getKind {
    return [ConsumerWrapper getNativeKind:self.nativeConsumer];
}

-(RTCMediaStreamTrack *)getTrack {
    return self.nativeTrack;
}

-(NSString *)getRtpParameters {
    return [ConsumerWrapper getNativeRtpParameters:self.nativeConsumer];
}

-(NSString *)getAppData {
    return [ConsumerWrapper getNativeAppData:self.nativeConsumer];
}

-(void)resume {
    [ConsumerWrapper nativeResume:self.nativeConsumer];
}

-(void)pause {
    [ConsumerWrapper nativePause:self.nativeConsumer];
}

-(NSString *)getStats {
    return [ConsumerWrapper getNativeStats:self.nativeConsumer];
}

-(void)close {
    [ConsumerWrapper nativeClose:self.nativeConsumer];
}

@end
