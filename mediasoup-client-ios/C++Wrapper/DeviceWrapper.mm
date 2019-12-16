//
//  DeviceWrapper.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#define MSC_CLASS "device_wrapper"

#import <libmediasoupclient/include/Device.hpp>
#import <libmediasoupclient/include/Logger.hpp>
#import <libmediasoupclient/include/Transport.hpp>

#import "include/DeviceWrapper.h"
#import "include/TransportWrapper.h"

using namespace mediasoupclient;

@implementation DeviceWrapper
+(NSValue *)nativeNewDevice {
    MSC_TRACE();
    
    mediasoupclient::Device *device = new mediasoupclient::Device();
    
    return [NSValue valueWithPointer:device];
}

+(void)nativeFreeDevice:(NSValue *)nativeDevice {
    MSC_TRACE();
    
    delete reinterpret_cast<mediasoupclient::Device *>([nativeDevice pointerValue]);
}

+(void)nativeLoad:(NSValue *)nativeDevice routerRtpCapabilities:(NSString *)routerRtpCapabilities {
    MSC_TRACE();
    
    try {
        nlohmann::json routerRtpCapabilitiesJson = nlohmann::json::parse(std::string([routerRtpCapabilities UTF8String]));
        reinterpret_cast<mediasoupclient::Device *>([nativeDevice pointerValue])->Load(routerRtpCapabilitiesJson);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"LoadException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(bool)nativeIsLoaded:(NSValue *)nativeDevice {
    MSC_TRACE();
    
    bool result = reinterpret_cast<mediasoupclient::Device *>([nativeDevice pointerValue])->IsLoaded();

    return result;
}

+(NSString *)nativeGetRtpCapabilities:(NSValue *)nativeDevice {
    MSC_TRACE();
    
    try {
        const nlohmann::json rtpCapabilities = reinterpret_cast<mediasoupclient::Device *>([nativeDevice pointerValue])->GetRtpCapabilities();
        std::string rtpCapabilitiesString = rtpCapabilities.dump();
        
        return [NSString stringWithUTF8String:rtpCapabilitiesString.c_str()];
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(bool)nativeCanProduce:(NSValue *)nativeDevice kind:(NSString *)kind {
    MSC_TRACE();
    
    try {
        std::string kindString = std::string([kind UTF8String]);
        bool result = reinterpret_cast<mediasoupclient::Device *>([nativeDevice pointerValue])->CanProduce(kindString);
        
        return result;
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(NSValue *)nativeCreateSendTransport:(NSValue *)nativeDevice listener:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    MSC_TRACE();
    
    try {
        auto transportListener = new SendTransportListenerWrapper(listener);
        const std::string idString = std::string([id UTF8String]);
        const std::string iceParametersString = std::string([iceParameters UTF8String]);
        const std::string iceCandidatesString = std::string([iceCandidates UTF8String]);
        const std::string dtlsParametersString = std::string([dtlsParameters UTF8String]);
        mediasoupclient::PeerConnection::Options* pcOptions = reinterpret_cast<mediasoupclient::PeerConnection::Options *>(options);
        
        nlohmann::json appDataJson = nlohmann::json::object();
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        mediasoupclient::SendTransport *nativeTransport = reinterpret_cast<mediasoupclient::Device *>([ nativeDevice pointerValue])->CreateSendTransport(transportListener, idString, nlohmann::json::parse(iceParametersString), nlohmann::json::parse(iceCandidatesString), nlohmann::json::parse(dtlsParametersString), pcOptions, appDataJson);
        
        return [NSValue valueWithPointer:nativeTransport];
    } catch(std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
    
    return nullptr;
}

+(NSValue *)nativeCreateRecvTransport:(NSValue *)nativeDevice listener:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    MSC_TRACE();
    
    try {
        auto transportListener = new RecvTransportListenerWrapper(listener);
        const std::string idString = std::string([id UTF8String]);
        const std::string iceParametersString = std::string([iceParameters UTF8String]);
        const std::string iceCandidatesString = std::string([iceCandidates UTF8String]);
        const std::string dtlsParametersString = std::string([dtlsParameters UTF8String]);
        
        mediasoupclient::PeerConnection::Options* pcOptions = reinterpret_cast<mediasoupclient::PeerConnection::Options *>(options);
        
        nlohmann::json appDataJson = nlohmann::json::object();
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        mediasoupclient::RecvTransport *nativeTransport = reinterpret_cast<mediasoupclient::Device *>([ nativeDevice pointerValue])->CreateRecvTransport(transportListener, idString, nlohmann::json::parse(iceParametersString), nlohmann::json::parse(iceCandidatesString), nlohmann::json::parse(dtlsParametersString), pcOptions, appDataJson);
        
        return [NSValue valueWithPointer:nativeTransport];
    } catch (std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
    
    return nullptr;
}

@end
