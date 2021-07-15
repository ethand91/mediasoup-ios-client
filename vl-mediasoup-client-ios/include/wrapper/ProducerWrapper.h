//
//  ProducerWrapper.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import "Producer.hpp"
#import "Producer.h"

#ifndef ProducerWrapper_h
#define ProducerWrapper_h

@interface ProducerWrapper : NSObject {}
+(NSString *)getNativeId:(NSValue *)nativeProducer;
+(bool)isNativeClosed:(NSValue *)nativeProducer;
+(NSString *)getNativeKind:(NSValue *)nativeProducer;
+(webrtc::MediaStreamTrackInterface *)getNativeTrack:(NSValue *)nativeProducer;
+(bool)isNativePaused:(NSValue *)nativeProducer;
+(int)getNativeMaxSpatialLayer:(NSValue *)nativeProducer;
+(NSString *)getNativeAppData:(NSValue *)nativeProducer;
+(NSString *)getNativeRtpParameters:(NSValue *)nativeProducer;
+(NSString *)getNativeStats:(NSValue *)nativeProducer;
+(void)nativeResume:(NSValue *)nativeProducer;
+(void)nativePause:(NSValue *)nativeProducer;
+(void)setNativeMaxSpatialLayer:(NSValue *)nativeProducer layer:(int)layer;
+(void)nativeReplaceTrack:(NSValue *)nativeProducer track:(NSUInteger)track;
+(void)nativeClose:(NSValue *)nativeProducer;

@end

class ProducerListenerWrapper final : public mediasoupclient::Producer::Listener {
private:
    Protocol<ProducerListener>* listener_;
    ::Producer* producer_;
public:
    ProducerListenerWrapper(Protocol<ProducerListener>* listener)
    : listener_(listener) {}
    
    ~ProducerListenerWrapper() {
        [producer_ release];
        [listener_ release];
    };
    
    void OnTransportClose(mediasoupclient::Producer* nativeProducer) override {
        [this->listener_ onTransportClose:this->producer_];
    };
    
    void SetProducer(::Producer *producer) {
        this->producer_ = producer;
    }
};

class OwnedProducer {
public:
    OwnedProducer(mediasoupclient::Producer* producer, ProducerListenerWrapper* listener)
    : producer_(producer), listener_(listener) {}
    
    ~OwnedProducer() {
        delete producer_;
        delete listener_;
    };
    
    mediasoupclient::Producer* producer() const { return producer_; }
    
private:
    mediasoupclient::Producer* producer_;
    ProducerListenerWrapper* listener_;
};

#endif /* ProducerWrapper_h */
