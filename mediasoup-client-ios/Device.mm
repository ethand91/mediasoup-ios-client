//
//  Device.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#include <iostream>

#import "Device.h"
#import "DeviceWrapper.h"

@implementation Device : NSObject

-(instancetype)init {
    self = [super init];
    if (self) {
        self._nativeDevice = [DeviceWrapper nativeNewDevice];
    }
    
    return self;
}

-(void)load:(NSString *)routerRtpCapabilities {
    [self checkDeviceExists];
    [DeviceWrapper nativeLoad:self._nativeDevice routerRtpCapabilities:routerRtpCapabilities];
}

-(bool)isLoaded {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeIsLoaded:self._nativeDevice];
}

-(NSString *)getRtpCapabilities {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeGetRtpCapabilities:self._nativeDevice];
}

-(bool)canProduce:(NSString *)kind {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeCanProduce:self._nativeDevice kind:kind];
}

-(SendTransport *)createSendTransport:(Protocol<SendTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    std::cout << "createSendTransport" << std::endl;
    return [self createSendTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters options:nil appData:nil];
}

-(SendTransport *)createSendTransport:(Protocol<SendTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    std::cout << "createSendTransport before check" << std::endl;
    [self checkDeviceExists];
    
    std::cout << "createSendTransport after check" << std::endl;
    NSObject *transport = [DeviceWrapper nativeCreateSendTransport:self._nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters options:options appData:appData];
    
    return [[SendTransport alloc] initWithNativeTransport:transport];
}

-(RecvTransport *)createRecvTransport:(Protocol<RecvTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    return [self createRecvTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters options:nil appData:nil];
}

-(RecvTransport *)createRecvTransport:(Protocol<RecvTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    [self checkDeviceExists];
    
    NSObject *transport = [DeviceWrapper nativeCreateRecvTransport:self._nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters options:options appData:appData];
    
    return [[RecvTransport alloc] initWithNativeTransport:transport];
}

-(void)checkDeviceExists {
    if (self._nativeDevice == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"Device has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
