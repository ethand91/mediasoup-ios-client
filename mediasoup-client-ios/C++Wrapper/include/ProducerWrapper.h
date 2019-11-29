//
//  ProducerWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "Producer.hpp"

#ifndef ProducerWrapper_h
#define ProducerWrapper_h

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

#endif /* ProducerWrapper_h */
