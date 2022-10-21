//
//  DataProducerWrapper.h
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#import "DataProducer.hpp"
#import "DataProducer.h"

#ifndef DataProducerWrapper_h
#define DataProducerWrapper_h

@interface DataProducerWrapper : NSObject {}
+(NSString *)getNativeId:(NSValue *)nativeProducer;
+(NSString *)getNativeSctpStreamParameters:(NSValue *)nativeProducer;
+(NSString *)getNativeReadyState:(NSValue *)nativeProducer;
+(NSString *)getNativeLabel:(NSValue *)nativeProducer;
+(NSString *)getNativeProtocol:(NSValue *)nativeProducer;
+(uint64_t)getNativeBufferedAmount:(NSValue *)nativeProducer;
+(NSString *)getNativeAppData:(NSValue *)nativeProducer;
+(bool)isNativeClosed:(NSValue *)nativeProducer;
+(void)nativeClose:(NSValue *)nativeProducer;
+(void)nativeSend:(NSValue *)nativeProducer buffer:(NSData *)buffer;

@end

class DataProducerListenerWrapper final : public mediasoupclient::DataProducer::Listener {
private:
    Protocol<DataProducerListener>* listener_;
    ::DataProducer* producer_;
public:
    DataProducerListenerWrapper(Protocol<DataProducerListener>* listener)
    : listener_(listener) {}
    
    ~DataProducerListenerWrapper() {
        [producer_ release];
        [listener_ release];
    };
    
    void OnOpen(mediasoupclient::DataProducer* nativeProducer) override {
        [this->listener_ onOpen:this->producer_];
    };
    
    void OnClose(mediasoupclient::DataProducer* nativeProducer) override {
        [this->listener_ onClose:this->producer_];
    };
    
    void OnBufferedAmountChange(mediasoupclient::DataProducer* nativeProducer, uint64_t sentDataSize) override {
        [this->listener_ onBufferedAmountChange:this->producer_ sentDataSize:sentDataSize];
    };
    
    void OnTransportClose(mediasoupclient::DataProducer* nativeProducer) override {
        [this->listener_ onTransportClose:this->producer_];
    };
    
    void SetProducer(::DataProducer *producer) {
        this->producer_ = producer;
    }
};

class OwnedDataProducer {
public:
    OwnedDataProducer(mediasoupclient::DataProducer* producer, DataProducerListenerWrapper* listener)
    : producer_(producer), listener_(listener) {}
    
    ~OwnedDataProducer() {
        delete producer_;
        delete listener_;
    };
    
    mediasoupclient::DataProducer* producer() const { return producer_; }
    
private:
    mediasoupclient::DataProducer* producer_;
    DataProducerListenerWrapper* listener_;
};


#endif /* DataProducerWrapper_h */
