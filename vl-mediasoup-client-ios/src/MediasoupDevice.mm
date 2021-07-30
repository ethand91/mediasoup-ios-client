//
//  Device.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MediasoupDevice.h"
#import "DeviceWrapper.h"

@interface MediasoupDevice()
@property(nonatomic, retain) NSValue *nativeDevice;
@end

@implementation MediasoupDevice : NSObject

-(instancetype)init {
    self = [super init];
    if (self) {
        self.nativeDevice = [DeviceWrapper nativeNewDevice];
    }
    
    return self;
}

-(void)dealloc {
    if (self.nativeDevice != nil) {
        [DeviceWrapper nativeFreeDevice: self.nativeDevice];
    }
    self.nativeDevice = nil;
    [super dealloc];
}

-(void)load:(NSString *)routerRtpCapabilities {
    [self checkDeviceExists];
    [DeviceWrapper nativeLoad:self.nativeDevice routerRtpCapabilities:routerRtpCapabilities];
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
    return [self createSendTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil options:nil appData:nil];
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    [self checkDeviceExists];
    
    NSObject *transport = [DeviceWrapper nativeCreateSendTransport:self.nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:sctpParameters options:options appData:appData];
    
    return [[SendTransport alloc] initWithNativeTransport:transport];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    return [self createRecvTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil options:nil appData:nil];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    [self checkDeviceExists];
    
    NSObject *transport = [DeviceWrapper nativeCreateRecvTransport:self.nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:sctpParameters options:options appData:appData];
    
    return [[RecvTransport alloc] initWithNativeTransport:transport];
}

-(void)checkDeviceExists {
    if (self.nativeDevice == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"Device has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
