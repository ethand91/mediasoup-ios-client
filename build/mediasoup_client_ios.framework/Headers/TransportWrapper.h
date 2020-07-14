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

class SendTransportListenerWrapper : public mediasoupclient::SendTransport::Listener {
private:
    Protocol<SendTransportListener>* listener_;
public:
    SendTransportListenerWrapper(Protocol<SendTransportListener>* listener)
    : listener_(listener) {}
    
    ~SendTransportListenerWrapper() {
        [listener_ release];
    }
    
    std::future<void> OnConnect(mediasoupclient::Transport* nativeTransport, const nlohmann::json& dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        NSValue* transportObject = [NSValue valueWithPointer:nativeTransport];
        SendTransport* sendTransport = [[[SendTransport alloc] initWithNativeTransport:transportObject] autorelease];
        
        [this->listener_ onConnect:sendTransport dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
        
        std::promise<void> promise;
        promise.set_value();
        
        return promise.get_future();
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport* nativeTransport, const std::string& connectionState) override {
        NSValue *transportObject = [NSValue valueWithPointer:nativeTransport];
        SendTransport *sendTransport = [[[SendTransport alloc] initWithNativeTransport:transportObject] autorelease];
        
        [this->listener_ onConnectionStateChange:sendTransport connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
    
    std::future<std::string> OnProduce(
                                       mediasoupclient::SendTransport* nativeTransport,
                                       const std::string& kind,
                                       nlohmann::json rtpParameters,
                                       const nlohmann::json& appData) override {
        
        const std::string rtpParametersString = rtpParameters.dump();
        const std::string appDataString = appData.dump();
        
        NSValue* transportObject = [NSValue valueWithPointer:nativeTransport];
        SendTransport* sendTransport = [[[SendTransport alloc] initWithNativeTransport:transportObject] autorelease];
        
        __block std::promise<std::string> promise;
        
        [this->listener_ onProduce:sendTransport
            kind: [NSString stringWithUTF8String: kind.c_str()]
            rtpParameters: [NSString stringWithUTF8String: rtpParametersString.c_str()]
            appData: [NSString stringWithUTF8String:appDataString.c_str()]
            callback: ^(NSString* id) {
                promise.set_value(std::string([id UTF8String]));
            }
         ];
        
        return promise.get_future();
    };
};

class RecvTransportListenerWrapper final : public mediasoupclient::RecvTransport::Listener {
private:
    Protocol<TransportListener>* listener_;
public:
    RecvTransportListenerWrapper(Protocol<TransportListener>* listener)
    : listener_(listener) {}
    
    ~RecvTransportListenerWrapper() {
        delete this;
    }

    std::future<void> OnConnect(mediasoupclient::Transport* nativeTransport, const nlohmann::json& dtlsParameters) override {
        const std::string dtlsParametersString = dtlsParameters.dump();
        
        NSValue* transportObject = [NSValue valueWithPointer:nativeTransport];
        RecvTransport* recvTransport = [[[RecvTransport alloc] initWithNativeTransport:transportObject] autorelease];
        
        [this->listener_ onConnect:recvTransport dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
        
        std::promise<void> promise;
        promise.set_value();
        
        return promise.get_future();
    };
    
    void OnConnectionStateChange(mediasoupclient::Transport* nativeTransport, const std::string& connectionState) override {
        NSValue *transportObject = [NSValue valueWithPointer:nativeTransport];
        RecvTransport *recvTransport = [[[RecvTransport alloc] initWithNativeTransport:transportObject] autorelease];
        
        [this->listener_ onConnectionStateChange:recvTransport connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    };
};

class OwnedSendTransport {
public:
    OwnedSendTransport(mediasoupclient::SendTransport* transport, SendTransportListenerWrapper* listener)
    : transport_(transport), listener_(listener) {}
    
    ~OwnedSendTransport() {
        delete transport_;
        delete listener_;
    }
    
    mediasoupclient::SendTransport* transport() const { transport_; }
    
private:
    mediasoupclient::SendTransport* transport_;
    SendTransportListenerWrapper* listener_;
};

class OwnedRecvTransport {
public:
    OwnedRecvTransport(mediasoupclient::RecvTransport* transport, RecvTransportListenerWrapper* listener)
    : transport_(transport), listener_(listener) {}
    
    ~OwnedRecvTransport() {
        delete transport_;
        delete listener_;
    }
    
    mediasoupclient::RecvTransport* transport() const { return transport_; }
    
private:
    mediasoupclient::RecvTransport* transport_;
    RecvTransportListenerWrapper* listener_;
};

#endif /* TransportWrapper_h */
