//
//  TransportWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "Transport.hpp"
#import "ProducerWrapper.h"
#import "ConsumerWrapper.h"

#ifndef TransportWrapper_h
#define TransportWrapper_h

// Listeners
@protocol TransportListenerWrapper <NSObject>
@required
-(void)onConnect:(NSObject *)transport dtlsParameters:(NSString *)dtlsParameters;

@optional
-(void)onConnectionStateChange:(NSObject *)transport connectionState:(NSString *)connectionState;
@end

@protocol SendTransportListenerWrapper <TransportListenerWrapper>
@required
-(NSString *)onProduce:(NSObject *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData;

@end

class SendTransportListenerWrapperImpl : public mediasoupclient::SendTransport::Listener {
private:
    Protocol<SendTransportListenerWrapper> *listener;
public:
    SendTransportListenerWrapperImpl(Protocol<SendTransportListenerWrapper> *listener) {
        this->listener = listener;
    };
    
    ~SendTransportListenerWrapperImpl() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *transport, const nlohmann::json &dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        [this->listener onConnect:reinterpret_cast<NSObject *>(transport) dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport *transport, const std::string &connectionState) override {
        [this->listener onConnectionStateChange:reinterpret_cast<NSObject *>(transport) connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
    
    std::future<std::string> OnProduce(
                                       mediasoupclient::SendTransport *transport,
                                       const std::string &kind,
                                       nlohmann::json rtpParameters,
                                       const nlohmann::json &appData) override {
        const std::string rtpParametersString = rtpParameters.dump();
        const std::string appDataString = appData.dump();
        
        [this->listener onProduce:reinterpret_cast<NSObject *>(transport)
                            kind:[NSString stringWithUTF8String:kind.c_str()]
                            rtpParameters:[NSString stringWithUTF8String:rtpParametersString.c_str()]
                            appData:[NSString stringWithUTF8String:appDataString.c_str()]];
    };
};

class RecvTransportListenerWrapperImpl : public mediasoupclient::RecvTransport::Listener {
private:
    Protocol<TransportListenerWrapper> *listener;
public:
    RecvTransportListenerWrapperImpl(Protocol<TransportListenerWrapper> *listener) {
        this->listener = listener;
    };
    
    ~RecvTransportListenerWrapperImpl() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *transport, const nlohmann::json &dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        [this->listener onConnect:reinterpret_cast<NSObject *>(transport) dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport *transport, const std::string &connectionState) override {
        [this->listener onConnectionStateChange:reinterpret_cast<NSObject *>(transport) connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
};

@interface TransportWrapper : NSObject {}
+(NSString *)getNativeId:(NSObject *)nativeTransport;
+(NSString *)getNativeConnectionState:(NSObject *)nativeTransport;
+(NSString *)getNativeAppData:(NSObject *)nativeTransport;
+(NSString *)getNativeStats:(NSObject *)nativeTransport;
+(bool)isNativeClosed:(NSObject *)nativeTransport;
+(void)nativeRestartIce:(NSObject *)nativeTransport iceParameters:(NSString *)iceParameters;
+(void)nativeUpdateIceServers:(NSObject *)nativeTransport iceServers:(NSString *)iceServers;
+(void)nativeClose:(NSObject *)nativeTransport;
+(NSObject *)nativeGetNativeTransport:(NSObject *)nativeTransport;
+(NSObject *)nativeProduce:(NSObject *)nativeTransport listener:(Protocol<ProducerListenerWrapper> *)listener track:(NSObject *)track encodings:(NSString *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData;
+(void)nativeFreeTransport:(NSObject *)nativeTransport;
+(NSObject *)nativeConsume:(NSObject *)nativeTransport listener:(Protocol<ConsumerListenerWrapper> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData;

@end

#endif /* TransportWrapper_h */
