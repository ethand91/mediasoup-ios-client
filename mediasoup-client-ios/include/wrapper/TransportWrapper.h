//
//  TransportWrapper.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import "Transport.hpp"
#import "ProducerWrapper.h"
#import "ConsumerWrapper.h"
#import "SendTransport.h"
#import "RecvTransport.h"
#import "Transport.h"

#ifndef TransportWrapper_h
#define TransportWrapper_h

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
+(::Producer *)nativeProduce:(NSValue *)nativeTransport listener:(Protocol<ProducerListener> *)listener track:(NSUInteger)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData;
+(void)nativeFreeTransport:(NSValue *)nativeTransport;
+(::Consumer *)nativeConsume:(NSValue *)nativeTransport listener:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData;
+(mediasoupclient::Transport *)extractNativeTransport:(NSValue *)nativeTransport;

@end

class OwnedSendTransport {
public:
    OwnedSendTransport(mediasoupclient::SendTransport *transport, mediasoupclient::SendTransport::Listener *listener)
    : transport_(transport), listener_(listener) {}
    
    ~OwnedSendTransport() = default;
    
    mediasoupclient::SendTransport *transport() const { return transport_.get(); }
    
private:
    std::unique_ptr<mediasoupclient::SendTransport> transport_;
    std::unique_ptr<mediasoupclient::SendTransport::Listener> listener_;
};

class SendTransportListenerWrapper : public mediasoupclient::SendTransport::Listener {
private:
    Protocol<SendTransportListener> *listener;
public:
    SendTransportListenerWrapper(Protocol<SendTransportListener> *listener) {
        this->listener = listener;
    };
    
    ~SendTransportListenerWrapper() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *nativeTransport, const nlohmann::json &dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        NSValue *transportObject = [NSValue valueWithPointer:nativeTransport];
        SendTransport *sendTransport = [[SendTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnect:sendTransport dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
        
        std::promise<void> promise;
        promise.set_value();
        
        return promise.get_future();
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport *nativeTransport, const std::string &connectionState) override {
        NSValue *transportObject = [NSValue valueWithPointer:nativeTransport];
        SendTransport *sendTransport = [[SendTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnectionStateChange:sendTransport connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
    
    std::future<std::string> OnProduce(
                                       mediasoupclient::SendTransport *nativeTransport,
                                       const std::string &kind,
                                       nlohmann::json rtpParameters,
                                       const nlohmann::json &appData) override {
        
        const std::string rtpParametersString = rtpParameters.dump();
        const std::string appDataString = appData.dump();
        
        NSValue * transportObject = [NSValue valueWithPointer:nativeTransport];
        SendTransport *sendTransport = [[SendTransport alloc] initWithNativeTransport:transportObject];
        
        auto result = [this->listener onProduce:sendTransport
                            kind:[NSString stringWithUTF8String:kind.c_str()]
                            rtpParameters:[NSString stringWithUTF8String:rtpParametersString.c_str()]
                            appData:[NSString stringWithUTF8String:appDataString.c_str()]];
        
        std::promise<std::string> promise;
        promise.set_value(std::string([result UTF8String]));
        
        return promise.get_future();
    };
};

class OwnedRecvTransport {
public:
    OwnedRecvTransport(mediasoupclient::RecvTransport *transport, mediasoupclient::RecvTransport::Listener *listener)
    : transport_(transport), listener_(listener) {}
    
    ~OwnedRecvTransport() = default;
    
    mediasoupclient::RecvTransport *transport() const { return transport_.get(); }
    
private:
    std::unique_ptr<mediasoupclient::RecvTransport> transport_;
    std::unique_ptr<mediasoupclient::RecvTransport::Listener> listener_;
};

class RecvTransportListenerWrapper : public mediasoupclient::RecvTransport::Listener {
private:
    Protocol<TransportListener> *listener;
public:
    RecvTransportListenerWrapper(Protocol<TransportListener> *listener) {
        this->listener = listener;
    };
    
    ~RecvTransportListenerWrapper() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *nativeTransport, const nlohmann::json &dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        NSValue *transportObject = [NSValue valueWithPointer:nativeTransport];
        RecvTransport *recvTransport = [[RecvTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnect:recvTransport dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
        
        std::promise<void> promise;
        promise.set_value();
        
        return promise.get_future();
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport *nativeTransport, const std::string &connectionState) override {
        NSValue *transportObject = [NSValue valueWithPointer:nativeTransport];
        RecvTransport *recvTransport = [[RecvTransport alloc] initWithNativeTransport:transportObject];
        
        [this->listener onConnectionStateChange:recvTransport connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
};

#endif /* TransportWrapper_h */
