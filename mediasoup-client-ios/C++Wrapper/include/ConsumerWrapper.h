//
//  ConsumerWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "Consumer.hpp"

#ifndef ConsumerWrapper_h
#define ConsumerWrapper_h

// Listeners
@protocol ConsumerListenerWrapper <NSObject>
@optional
-(void)onTransportClose:(NSObject *)consumer;
@end

class ConsumerListener : public mediasoupclient::Consumer::Listener {
public:
    ConsumerListener(Protocol<ConsumerListenerWrapper> *listener) {}
    
    ~ConsumerListener() = default;
    
    void OnTransportClose(mediasoupclient::Consumer *consumer) override {};
};

@interface ConsumerWrapper : NSObject
@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSString *localId;
@property (nonatomic, readonly) NSString *producerId;
@property (nonatomic, readonly) NSObject *track;
@property (nonatomic, readonly) NSObject *rtpParameters;
@property (nonatomic, readonly) NSObject *appData;
-(instancetype)initWithConsumer:(mediasoupclient::Consumer *)consumer;
@end

@interface ConsumerWrapper ()
@property (atomic, readonly, assign) mediasoupclient::Consumer *consumer;
@end

// Listeners
@protocol ConsumerWrapperListener <NSObject>
@optional
-(void)onTransportClose:(NSObject *)consumer;

@end


#endif /* ConsumerWrapper_h */
