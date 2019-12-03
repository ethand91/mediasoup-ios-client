//
//  ProducerWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "Producer.hpp"
#import "Producer.h"

#ifndef ProducerWrapper_h
#define ProducerWrapper_h

@interface ProducerWrapper : NSObject {}
+(NSString *)getNativeId:(NSObject *)nativeProducer;
+(bool)isNativeClosed:(NSObject *)nativeProducer;
+(NSString *)getNativeKind:(NSObject *)nativeProducer;
+(NSObject *)getNativeTrack:(NSObject *)nativeProducer;
+(bool)isNativePaused:(NSObject *)nativeProducer;
+(int)getNativeMaxSpatialLayer:(NSObject *)nativeProducer;
+(NSString *)getNativeAppData:(NSObject *)nativeProducer;
+(NSString *)getNativeRtpParameters:(NSObject *)nativeProducer;
+(NSString *)getNativeStats:(NSObject *)nativeProducer;
+(void)nativeResume:(NSObject *)nativeProducer;
+(void)nativePause:(NSObject *)nativeProducer;
+(void)setNativeMaxSpatialLayer:(NSObject *)nativeProducer layer:(int)layer;
+(void)nativeReplaceTrack:(NSObject *)nativeProducer track:(NSObject *)track;
+(void)nativeClose:(NSObject *)nativeProducer;

@end

class ProducerListenerWrapper : public mediasoupclient::Producer::Listener {
private:
    Protocol<ProducerListener> *listener;
public:
    ProducerListenerWrapper(Protocol<ProducerListener> *listener) {
        this->listener = listener;
    };
    
    ~ProducerListenerWrapper() = default;
    
    void OnTransportClose(mediasoupclient::Producer *producer) override {
        [this->listener onTransportClose:reinterpret_cast<NSObject *>(producer)];
    };
};

#endif /* ProducerWrapper_h */
