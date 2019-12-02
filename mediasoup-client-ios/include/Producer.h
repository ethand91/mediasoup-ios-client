//
//  Producer.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import "WebRTC/RTCMediaStreamTrack.h"

#ifndef Producer_h
#define Producer_h

@interface Producer : NSObject
@property(nonatomic) NSObject* _nativeProducer;

-(NSString *)getId;
-(bool)isClosed;
-(NSString *)getKind;
-(RTCMediaStreamTrack *)getTrack;
-(bool)isPaused;
-(int)getMaxSpatialLayer;
-(NSString *)getAppData;
-(NSString *)getRtpParameters;
-(void)resume;
-(void)pause;
-(void)setMaxSpatialLayers:(int)layer;
-(void)replaceTrack:(RTCMediaStreamTrack *)track;
-(NSString *)getStats;
-(void)close;

@end

@protocol ProducerListener <NSObject>

-(void)onTransportClose:(Producer *)producer;

@end

#endif /* Producer_h */
