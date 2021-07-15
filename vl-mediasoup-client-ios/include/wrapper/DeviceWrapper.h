//
//  DeviceWrapper.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactoryOptions.h>

#import "Device.hpp"
#import "SendTransport.h"
#import "RecvTransport.h"

#ifndef DeviceWrapper_h
#define DeviceWrapper_h

@interface DeviceWrapper : NSObject {}
+(NSValue *)nativeNewDevice;
+(void)nativeFreeDevice:(NSValue *)nativeDevice;
+(void)nativeLoad:(NSValue *)nativeDevice routerRtpCapabilities:(NSString *)routerRtpCapabilities;
+(bool)nativeIsLoaded:(NSValue *)nativeDevice;
+(NSString *)nativeGetRtpCapabilities:(NSValue *)nativeDevice;
+(NSString *)nativeGetSctpCapabilities:(NSValue *)nativeDevice;
+(bool)nativeCanProduce:(NSValue *)nativeDevice kind:(NSString *)kind;
+(NSValue *)nativeCreateSendTransport:(NSValue *)nativeDevice listener:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
+(NSValue *)nativeCreateRecvTransport:(NSValue *)nativeDevice listener:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters: (NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
@end

#endif /* DeviceWrapper_h */
