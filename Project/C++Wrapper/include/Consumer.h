//
//  Consumer.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#include "Consumer.hpp"

#ifndef Consumer_h
#define Consumer_h

@interface ConsumerWrapper : NSObject
@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSString *localId;
@property (nonatomic, readonly) NSString *producerId;
@property (nonatomic, readonly) NSObject *track;
@property (nonatomic, readonly) NSObject *rtpParameters;
@property (nonatomic, readonly) NSObject *appData;
@end

@interface ConsumerWrapper ()
@property (atomic, readonly, assign) mediasoupclient::Consumer *consumer;
@end

// Listeners
@protocol ConsumerWrapperListener <NSObject>
@optional
-(void)onTransportClose:(NSObject *)consumer;

@end


#endif /* Consumer_h */
