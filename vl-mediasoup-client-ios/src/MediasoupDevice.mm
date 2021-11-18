//
//  Device.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MediasoupDevice.h"
#import "SendTransport.h"
#import "RecvTransport.h"
#import "DeviceWrapper.h"
#import <libmediasoupclient/include/PeerConnection.hpp>
#import "peerconnection/RTCPeerConnectionFactory+Private.h"
#import "peerconnection/RTCPeerConnectionFactoryBuilder+DefaultComponents.h"

using namespace mediasoupclient;

@interface MediasoupDevice()
@property(nonatomic, strong) NSValue *nativeDevice;
@property(nonatomic, strong) RTCPeerConnectionFactoryBuilder *pcFactoryBuilder;
@property(nonatomic, strong) RTCPeerConnectionFactory *pcFactory;
@property(nonatomic, strong) NSValue *nativePCOptions;
@end

@implementation MediasoupDevice : NSObject

-(instancetype)init {
    self = [super init];
    if (self) {
        self.nativeDevice = [DeviceWrapper nativeNewDevice];

        self.pcFactoryBuilder = [RTCPeerConnectionFactoryBuilder defaultBuilder];
        self.pcFactory = [self.pcFactoryBuilder createPeerConnectionFactory];
        auto pcOptions = new mediasoupclient::PeerConnection::Options();
        pcOptions->factory = self.pcFactory.nativeFactory;

        self.nativePCOptions = [NSValue valueWithPointer:pcOptions];
    }
    
    return self;
}

-(void)dealloc {
    if (self.nativeDevice != nil) {
        [DeviceWrapper nativeFreeDevice: self.nativeDevice];
    }
    self.nativeDevice = nil;

    self.pcFactoryBuilder = nil;

    if (self.nativePCOptions != nil && self.nativePCOptions.pointerValue != nullptr) {
        delete reinterpret_cast<mediasoupclient::PeerConnection::Options *>(self.nativePCOptions.pointerValue);
    }
    self.nativePCOptions = nil;
}

-(void)load:(NSString *)routerRtpCapabilities {
    [self checkDeviceExists];
    [DeviceWrapper nativeLoad:self.nativeDevice routerRtpCapabilities:routerRtpCapabilities nativePCOptions:self.nativePCOptions];
}

-(bool)isLoaded {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeIsLoaded:self.nativeDevice];
}

-(NSString *)getRtpCapabilities {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeGetRtpCapabilities:self.nativeDevice];
}

-(NSString *)getSctpCapabilities {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeGetSctpCapabilities:self.nativeDevice];
}

-(bool)canProduce:(NSString *)kind {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeCanProduce:self.nativeDevice kind:kind];
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    return [self createSendTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil appData:nil];
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters appData:(NSString *)appData {
    [self checkDeviceExists];

    return [DeviceWrapper nativeCreateSendTransport:self.nativeDevice listener:listener
        pcFactory:self.pcFactory id:id iceParameters:iceParameters iceCandidates:iceCandidates
        dtlsParameters:dtlsParameters sctpParameters:sctpParameters
        nativePCOptions:self.nativePCOptions appData:appData];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    return [self createRecvTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil appData:nil];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters appData:(NSString *)appData {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeCreateRecvTransport:self.nativeDevice listener:listener
        pcFactory:self.pcFactory id:id iceParameters:iceParameters iceCandidates:iceCandidates
        dtlsParameters:dtlsParameters sctpParameters:sctpParameters
        nativePCOptions:self.nativePCOptions appData:appData];
}

-(void)checkDeviceExists {
    if (self.nativeDevice == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"Device has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
