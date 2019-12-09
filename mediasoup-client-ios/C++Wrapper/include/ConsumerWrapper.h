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
+(NSString *)getNativeId:(NSValue *)nativeConsumer;
+(NSString *)getNativeProducerId:(NSValue *)nativeConsumer;
+(bool)isNativeClosed:(NSValue *)nativeConsumer;
+(bool)isNativePaused:(NSValue *)nativeConsumer;
+(NSString *)getNativeKind:(NSValue *)nativeConsumer;
+(webrtc::MediaStreamTrackInterface *)getNativeTrack:(NSValue *)nativeConsumer;
+(NSString *)getNativeRtpParameters:(NSValue *)nativeConsumer;
+(NSString *)getNativeAppData:(NSValue *)nativeConsumer;
+(void)nativeResume:(NSValue *)nativeConsumer;
+(void)nativePause:(NSValue *)nativeConsumer;
+(NSString *)getNativeStats:(NSValue *)nativeConsumer;
+(void)nativeClose:(NSValue *)nativeConsumer;

@end

class OwnedConsumer {
public:
    OwnedConsumer(mediasoupclient::Consumer *consumer, mediasoupclient::Consumer::Listener *listener)
    : consumer_(consumer), listener_(listener) {}
    
    ~OwnedConsumer() = default;
    
    mediasoupclient::Consumer *consumer() const { return consumer_.get(); }
    
private:
    std::unique_ptr<mediasoupclient::Consumer> consumer_;
    std::unique_ptr<mediasoupclient::Consumer::Listener> listener_;
};

class ConsumerListenerWrapper : public mediasoupclient::Consumer::Listener {
private:
    Protocol<ConsumerListener> *listener;
public:
    ConsumerListenerWrapper(Protocol<ConsumerListener> *listener) {
        this->listener = listener;
    }
    
    ~ConsumerListenerWrapper() = default;
    
    void OnTransportClose(mediasoupclient::Consumer *nativeConsumer) override {
        NSValue *consumerObject = [NSValue valueWithPointer:nativeConsumer];
        Consumer *consumer = [[Consumer alloc] initWithNativeConsumer:consumerObject];
        
        [this->listener onTransportClose:consumer];
    };
};

#endif /* ConsumerWrapper_h */
