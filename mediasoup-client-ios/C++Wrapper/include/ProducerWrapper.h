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
+(NSString *)getNativeId:(NSValue *)nativeProducer;
+(bool)isNativeClosed:(NSValue *)nativeProducer;
+(NSString *)getNativeKind:(NSValue *)nativeProducer;
+(NSObject *)getNativeTrack:(NSValue *)nativeProducer;
+(bool)isNativePaused:(NSValue *)nativeProducer;
+(int)getNativeMaxSpatialLayer:(NSValue *)nativeProducer;
+(NSString *)getNativeAppData:(NSValue *)nativeProducer;
+(NSString *)getNativeRtpParameters:(NSValue *)nativeProducer;
+(NSString *)getNativeStats:(NSValue *)nativeProducer;
+(void)nativeResume:(NSValue *)nativeProducer;
+(void)nativePause:(NSValue *)nativeProducer;
+(void)setNativeMaxSpatialLayer:(NSValue *)nativeProducer layer:(int)layer;
+(void)nativeReplaceTrack:(NSValue *)nativeProducer track:(NSValue *)track;
+(void)nativeClose:(NSValue *)nativeProducer;

@end

class ProducerListenerWrapper : public mediasoupclient::Producer::Listener {
private:
    Protocol<ProducerListener> *listener;
public:
    ProducerListenerWrapper(Protocol<ProducerListener> *listener) {
        this->listener = listener;
    };
    
    ~ProducerListenerWrapper() = default;
    
    void OnTransportClose(mediasoupclient::Producer *nativeProducer) override {
        NSValue *producerObject = [NSValue valueWithPointer:nativeProducer];
        Producer *producer = [[Producer alloc] initWithNativeProducer:producerObject];
        
        [this->listener onTransportClose:producer];
    };
};

#endif /* ProducerWrapper_h */
