//
//  TransportWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#include "Transport.hpp"

#ifndef TransportWrapper_h
#define TransportWrapper_h

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

class SendTransportListener : public mediasoupclient::SendTransport::Listener {
public:
    SendTransportListener(Protocol<SendTransportListenerWrapper> *listener) {};
    
    ~SendTransportListener() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *transport, const nlohmann::json &dtlsParameters) override {};
    
    void OnConnectionStateChange(mediasoupclient::Transport *transport, const std::string &connectionState) override {};
    
    std::future<std::string> OnProduce(
                                       mediasoupclient::SendTransport *transport,
                                       const std::string &kind,
                                       nlohmann::json rtpParameters,
                                       const nlohmann::json &appData) override {};
};

class RecvTransportListener : public mediasoupclient::RecvTransport::Listener {
public:
    RecvTransportListener(Protocol<TransportListenerWrapper> *listener) {};
    
    ~RecvTransportListener() = default;
    
    std::future<void> OnConnect(mediasoupclient::Transport *transport, const nlohmann::json &dtlsParameters) override {};
    
    void OnConnectionStateChange(mediasoupclient::Transport *transport, const std::string &connectionState) override {};
};

@interface TransportWrapper : NSObject
@property(nonatomic, weak)id<TransportListenerWrapper> listener;
@property(nonatomic, readonly)NSObject *iceParameters;
@property(nonatomic, readonly)NSObject *iceCandidates;
@property(nonatomic, readonly)NSObject *dtlsParameters;
@property(nonatomic, readonly)NSObject *peerConnectionOptions;
@property(nonatomic, readonly)NSObject *extendedRtpCapabilities;
@property(nonatomic, readonly)NSObject *canProduceByKind;
@property(nonatomic, readonly)NSObject *appData;
@end

@interface TransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::Transport *transport;
@end

@interface SendTransportWrapper : TransportWrapper
@property(nonatomic, weak)id<SendTransportListenerWrapper> listener;
-(instancetype)initWithTransport:(mediasoupclient::Transport *)transport;
@end

@interface SendTransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::SendTransport *sendTransport;
-(instancetype)initWithSendTransport:(mediasoupclient::SendTransport *)sendTransport;
@end

@interface RecvTransportWrapper : TransportWrapper
@end

@interface RecvTransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::RecvTransport *recvTransport;
-(instancetype)initWithRecvTransport:(mediasoupclient::RecvTransport *)recvTransport;
@end

#endif /* TransportWrapper_h */
