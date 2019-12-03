//
//  ConsumerWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "Consumer.hpp"
#import "Consumer.h"

#ifndef ConsumerWrapper_h
#define ConsumerWrapper_h

@interface ConsumerWrapper : NSObject {}
+(NSString *)getNativeId:(NSObject *)nativeConsumer;
+(NSString *)getNativeProducerId:(NSObject *)nativeConsumer;
+(bool)isNativeClosed:(NSObject *)nativeConsumer;
+(bool)isNativePaused:(NSObject *)nativeConsumer;
+(NSString *)getNativeKind:(NSObject *)nativeConsumer;
+(NSObject *)getNativeTrack:(NSObject *)nativeConsumer;
+(NSString *)getNativeRtpParameters:(NSObject *)nativeConsumer;
+(NSString *)getNativeAppData:(NSObject *)nativeConsumer;
+(void)nativeResume:(NSObject *)nativeConsumer;
+(void)nativePause:(NSObject *)nativeConsumer;
+(NSString *)getNativeStats:(NSObject *)nativeConsumer;
+(void)nativeClose:(NSObject *)nativeConsumer;

@end

class ConsumerListenerWrapper : public mediasoupclient::Consumer::Listener {
private:
    Protocol<ConsumerListener> *listener;
public:
    ConsumerListenerWrapper(Protocol<ConsumerListener> *listener) {
        this->listener = listener;
    }
    
    ~ConsumerListenerWrapper() = default;
    
    void OnTransportClose(mediasoupclient::Consumer *consumer) override {
        [this->listener onTransportClose:reinterpret_cast<NSObject *>(consumer)];
    };
};

#endif /* ConsumerWrapper_h */
