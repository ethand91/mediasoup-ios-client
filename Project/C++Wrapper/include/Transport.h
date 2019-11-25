//
//  Transport.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef Transport_h
#define Transport_h

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
@end

@interface SendTransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::SendTransport *sendTransport;
@end

@interface RecvTransportWrapper : TransportWrapper
@end

@interface RecvTransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::RecvTransport *recvTransport;
@end

#endif /* Transport_h */
