//
//  Producer.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#include "Producer.hpp"

#ifndef Producer_h
#define Producer_h

// Listeners
@protocol ProducerListenerWrapper <NSObject>
@optional
-(void)onTransportClose:(NSObject *)producer;
@end

class ProducerListener : public mediasoupclient::Producer::Listener {
public:
    ProducerListener(Protocol<ProducerListenerWrapper> *listener) {};
    
    ~ProducerListener() = default;
    
    void OnTransportClose(mediasoupclient::Producer *producer) override {};
};

/*
@interface ProducerListenerImpl : NSObject
@property(nonatomic, weak)id<ProducerListenerWrapper> listener;
@end
 */

/*
@implementation ProducerListenerImpl
@synthesize listener = _listener;

-(instancetype)init:(Protocol<ProducerListenerWrapper> *)listener {
    self = [super init];
    if (self) {
        _listener = listener;
    }
    
    return self;
}

-(void)onTransportClose:(mediasoupclient::Producer *)producer {
    if([self.listener respondsToSelector:@selector(onTransportClose:)]) {
        [self.listener onTransportClose:(__bridge NSObject *)producer];
    }
}
@end
 */

@interface ProducerWrapper : NSObject
@property(nonatomic, readonly) NSString *id;
@property(nonatomic, readonly) NSString *localId;
@property(nonatomic, readonly) NSObject *track;
@property(nonatomic, readonly) NSObject *rtpParameters;
@property(nonatomic, readonly) NSObject *appData;
-(instancetype)initWithProducer:(mediasoupclient::Producer *)producer;
@end

@interface ProducerWrapper ()
@property (atomic, readonly, assign) mediasoupclient::Producer *producer;
@end

#endif /* Producer_h */
