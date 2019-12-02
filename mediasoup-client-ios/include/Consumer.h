//
//  Consumer.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import "WebRTC/RTCMediaStreamTrack.h"

#ifndef Consumer_h
#define Consumer_h

@interface Consumer : NSObject
@property(nonatomic) NSObject* _nativeConsumer;

-(NSString *)getId;
-(NSString *)getProducerId;
-(bool)isClosed;
-(bool)isPaused;
-(NSString *)getKind;
-(RTCMediaStreamTrack *)getTrack;
-(NSString *)getRtpParameters;
-(NSString *)getAppData;
-(void)resume;
-(void)pause;
-(NSString *)getStats;
-(void)close;

@end

@protocol ConsumerListener <NSObject>

-(void)onTransportClose:(Consumer *)consumer;

@end

#endif /* Consumer_h */
