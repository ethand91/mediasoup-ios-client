//
//  TransportWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#include <iostream>
#import "Transport.hpp"
#import "ProducerWrapper.h"
#import "ConsumerWrapper.h"
#import "SendTransport.h"
#import "RecvTransport.h"
#import "Transport.h"

#ifndef TransportWrapper_h
#define TransportWrapper_h

class SendTransportListenerWrapper : public mediasoupclient::SendTransport::Listener {
private:
    Protocol<SendTransportListener> *listener;
public:
    SendTransportListenerWrapper(Protocol<SendTransportListener> *listener) {
        this->listener = listener;
    };
    
    ~SendTransportListenerWrapper() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *transport, const nlohmann::json &dtlsParameters) override {
        std::cout << "onConnect" << std::endl;
        
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        NSValue *transportObject = [NSValue valueWithPointer:transport];
        SendTransport *sendTransport = [[SendTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnect:sendTransport dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
        
        std::promise<void> promise;
        promise.set_value();
        
        return promise.get_future();
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport *transport, const std::string &connectionState) override {
        std::cout << "onConnectionStateChange : " << connectionState << std::endl;
        
        NSValue *transportObject = [NSValue valueWithPointer:transport];
        SendTransport *sendTransport = [[SendTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnectionStateChange:sendTransport connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
    
    std::future<std::string> OnProduce(
                                       mediasoupclient::SendTransport *transport,
                                       const std::string &kind,
                                       nlohmann::json rtpParameters,
                                       const nlohmann::json &appData) override {
        std::cout << "onProduce" << std::endl;
        
        const std::string rtpParametersString = rtpParameters.dump();
        const std::string appDataString = appData.dump();
        
        NSValue * transportObject = [NSValue valueWithPointer:transport];
        SendTransport *sendTransport = [[SendTransport alloc] initWithNativeTransport:transportObject];
        
        auto result = [this->listener onProduce:sendTransport
                            kind:[NSString stringWithUTF8String:kind.c_str()]
                            rtpParameters:[NSString stringWithUTF8String:rtpParametersString.c_str()]
                            appData:[NSString stringWithUTF8String:appDataString.c_str()]];
        std::cout << "onProduce result = " << result << std::endl;
        
        std::promise<std::string> promise;
        promise.set_value(std::string([result UTF8String]));
        
        return promise.get_future();
    };
};

class RecvTransportListenerWrapper : public mediasoupclient::RecvTransport::Listener {
private:
    Protocol<TransportListener> *listener;
public:
    RecvTransportListenerWrapper(Protocol<TransportListener> *listener) {
        this->listener = listener;
    };
    
    ~RecvTransportListenerWrapper() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *transport, const nlohmann::json &dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        NSValue *transportObject = [NSValue valueWithPointer:transport];
        RecvTransport *recvTransport = [[RecvTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnect:recvTransport dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
        
        std::promise<void> promise;
        promise.set_value();
        
        return promise.get_future();
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport *transport, const std::string &connectionState) override {
        std::cout << "onConnectionStateChange : " << connectionState << std::endl;
        
        NSValue *transportObject = [NSValue valueWithPointer:transport];
        RecvTransport *recvTransport = [[RecvTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnectionStateChange:recvTransport connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
};

@interface TransportWrapper : NSObject {}
+(NSString *)getNativeId:(NSValue *)nativeTransport;
+(NSString *)getNativeConnectionState:(NSValue *)nativeTransport;
+(NSString *)getNativeAppData:(NSValue *)nativeTransport;
+(NSString *)getNativeStats:(NSValue *)nativeTransport;
+(bool)isNativeClosed:(NSValue *)nativeTransport;
+(void)nativeRestartIce:(NSValue *)nativeTransport iceParameters:(NSString *)iceParameters;
+(void)nativeUpdateIceServers:(NSValue *)nativeTransport iceServers:(NSString *)iceServers;
+(void)nativeClose:(NSValue *)nativeTransport;
+(NSValue *)nativeGetNativeTransport:(NSValue *)nativeTransport;
+(NSObject *)nativeProduce:(NSValue *)nativeTransport listener:(Protocol<ProducerListener> *)listener track:(NSObject *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData;
+(void)nativeFreeTransport:(NSValue *)nativeTransport;
+(NSObject *)nativeConsume:(NSValue *)nativeTransport listener:(Protocol<ConsumerListener> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData;
+(mediasoupclient::Transport *)extractNativeTransport:(NSValue *)nativeTransport;

@end

#endif /* TransportWrapper_h */
