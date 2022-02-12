//
//  DataConsumerWrapper.h
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#import "DataConsumer.hpp"
#import "DataConsumer.h"

#ifndef DataConsumerWrapper_h
#define DataConsumerWrapper_h

@interface DataConsumerWrapper : NSObject {}
+(NSString *)getNativeId:(NSValue *)nativeConsumer;
+(NSString *)getNativeDataProducerId:(NSValue *)nativeConsumer;
+(NSString *)getNativeSctpStreamParameters:(NSValue *)nativeConsumer;
+(NSString *)getNativeReadyState:(NSValue *)nativeConsumer;
+(NSString *)getNativeLabel:(NSValue *)nativeConsumer;
+(NSString *)getNativeProtocol:(NSValue *)nativeConsumer;
+(NSString *)getNativeAppData:(NSValue *)nativeConsumer;
+(bool)isNativeClosed:(NSValue *)nativeConsumer;
+(void)nativeClose:(NSValue *)nativeConsumer;

@end

class DataConsumerListenerWrapper final : public mediasoupclient::DataConsumer::Listener {
private:
    Protocol<DataConsumerListener>* listener_;
    ::DataConsumer* consumer_;
public:
    DataConsumerListenerWrapper(Protocol<DataConsumerListener>* listener)
    : listener_(listener) {}
    
    ~DataConsumerListenerWrapper() {
        [consumer_ release];
        [listener_ release];
    };
    
    void OnConnecting(mediasoupclient::DataConsumer* nativeConsumer) override {
        [this->listener_ onConnecting:this->consumer_];
    };
    
    void OnOpen(mediasoupclient::DataConsumer* nativeConsumer) override {
        [this->listener_ onOpen:this->consumer_];
    };
    
    void OnClosing(mediasoupclient::DataConsumer* nativeConsumer) override {
        [this->listener_ onClosing:this->consumer_];
    };
    
    void OnClose(mediasoupclient::DataConsumer* nativeConsumer) override {
        [this->listener_ onClose:this->consumer_];
    };
    
    void OnMessage(mediasoupclient::DataConsumer* dataConsumer, const webrtc::DataBuffer& buffer) override {

        auto cptr = buffer.data.cdata();
        auto length = buffer.data.size();
        NSData *data = [NSData dataWithBytes:cptr length:length];
        [this->listener_ onMessage:this->consumer_ buffer:data];
    };
    
    void OnTransportClose(mediasoupclient::DataConsumer* nativeConsumer) override {
        [this->listener_ onTransportClose:this->consumer_];
    };
    
    void SetConsumer(::DataConsumer *consumer) {
        this->consumer_ = consumer;
    }
};

class OwnedDataConsumer {
public:
    OwnedDataConsumer(mediasoupclient::DataConsumer* consumer, DataConsumerListenerWrapper* listener)
    : consumer_(consumer), listener_(listener) {}
    
    ~OwnedDataConsumer() {
        delete consumer_;
        delete listener_;
    };
    
    mediasoupclient::DataConsumer* consumer() const { return consumer_; }
    
private:
    mediasoupclient::DataConsumer* consumer_;
    DataConsumerListenerWrapper* listener_;
};


#endif /* DataConsumerWrapper_h */
