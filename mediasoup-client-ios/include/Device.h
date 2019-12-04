//
//  Device.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/11/29.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactoryOptions.h>

#import "SendTransport.h"
#import "RecvTransport.h"

#ifndef Device_h
#define Device_h

@interface Device : NSObject
@property(nonatomic) NSValue* _nativeDevice;

-(id)init;
-(void)dispose;
-(void)load:(NSString *)routerRtpCapabilities;
-(bool)isLoaded;
-(NSString *)getRtpCapabilities;
-(bool)canProduce:(NSString *)kind;
-(SendTransport *)createSendTransport:(Protocol<SendTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters;
-(SendTransport *)createSendTransport:(Protocol<SendTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
-(RecvTransport *)createRecvTransport:(Protocol<RecvTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters;
-(RecvTransport *)createRecvTransport:(Protocol<RecvTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
@end

#endif /* Device_h */
