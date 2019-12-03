//
//  DeviceWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WebRTC/RTCPeerConnectionFactoryOptions.h"
#import "Device.hpp"
#import "SendTransport.h"
#import "RecvTransport.h"

#ifndef DeviceWrapper_h
#define DeviceWrapper_h

@interface DeviceWrapper : NSObject {}
+(NSObject *)nativeNewDevice;
+(void)nativeFreeDevice:(NSObject *)nativeDevice;
+(void)nativeLoad:(NSObject *)nativeDevice routerRtpCapabilities:(NSString *)routerRtpCapabilities;
+(bool)nativeIsLoaded:(NSObject *)nativeDevice;
+(NSString *)nativeGetRtpCapabilities:(NSObject *)nativeDevice;
+(bool)nativeCanProduce:(NSObject *)nativeDevice kind:(NSString *)kind;
+(NSValue *)nativeCreateSendTransport:(NSObject *)nativeDevice listener:(Protocol<SendTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
+(NSValue *)nativeCreateRecvTransport:(NSObject *)nativeDevice listener:(Protocol<RecvTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
@end

#endif /* DeviceWrapper_h */
