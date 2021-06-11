//
//  ConsumerWrapper.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
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

class ConsumerListenerWrapper final : public mediasoupclient::Consumer::Listener {
private:
    Protocol<ConsumerListener>* listener_;
    ::Consumer* consumer_;
public:
    ConsumerListenerWrapper(Protocol<ConsumerListener>* listener)
    : listener_(listener) {}
    
    ~ConsumerListenerWrapper() {
        [consumer_ release];
        [listener_ release];
    }
    
    void OnTransportClose(mediasoupclient::Consumer* nativeConsumer) override {
        [this->listener_ onTransportClose:this->consumer_];
    };
    
    void SetConsumer(::Consumer *consumer) {
        this->consumer_ = consumer;
    }
};

class OwnedConsumer {
public:
    OwnedConsumer(mediasoupclient::Consumer* consumer, mediasoupclient::Consumer::Listener* listener)
    : consumer_(consumer), listener_(listener) {}
    
    ~OwnedConsumer() {
        delete listener_;
        delete consumer_;
    };
    
    mediasoupclient::Consumer *consumer() const { return consumer_; }
    
private:
    mediasoupclient::Consumer* consumer_;
    mediasoupclient::Consumer::Listener* listener_;
};

#endif /* ConsumerWrapper_h */
