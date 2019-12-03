#include <iostream>

#import "Device.hpp"
#import "Transport.hpp"
#import "include/DeviceWrapper.h"
#import "include/TransportWrapper.h"

@implementation DeviceWrapper
+(NSObject *)nativeNewDevice {
    mediasoupclient::Device *device = new mediasoupclient::Device();
    
    return reinterpret_cast<NSObject *>(device);
}

+(void)nativeFreeDevice:(NSObject *)nativeDevice {
    delete reinterpret_cast<mediasoupclient::Device *>(nativeDevice);
}

+(void)nativeLoad:(NSObject *)nativeDevice routerRtpCapabilities:(NSString *)routerRtpCapabilities {
    try {
        nlohmann::json routerRtpCapabilitiesJson = nlohmann::json::parse(std::string([routerRtpCapabilities UTF8String]));
        reinterpret_cast<mediasoupclient::Device *>(nativeDevice)->Load(routerRtpCapabilitiesJson);
    } catch (const std::exception &e) {
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"LoadException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(bool)nativeIsLoaded:(NSObject *)nativeDevice {
    bool result = reinterpret_cast<mediasoupclient::Device *>(nativeDevice)->IsLoaded();

    return result;
}

+(NSString *)nativeGetRtpCapabilities:(NSObject *)nativeDevice {
    try {
        const nlohmann::json rtpCapabilities = ((__bridge mediasoupclient::Device *)nativeDevice)->GetRtpCapabilities();
        std::string rtpCapabilitiesString = rtpCapabilities.dump();
        
        return [NSString stringWithUTF8String:rtpCapabilitiesString.c_str()];
    } catch (const std::exception &e) {
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(bool)nativeCanProduce:(NSObject *)nativeObject kind:(NSString *)kind {
    try {
        std::string kindString = std::string([kind UTF8String]);
        bool result = reinterpret_cast<mediasoupclient::Device *>(nativeObject)->CanProduce(kindString);
        
        return result;
    } catch (const std::exception &e) {
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(NSValue *)nativeCreateSendTransport:(NSObject *)nativeDevice listener:(Protocol<SendTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    try {
        std::cout << "nativeCreateSendTransport" << std::endl;
        
        auto transportListener = new SendTransportListenerWrapper(listener);
        const std::string idString = std::string([id UTF8String]);
        const std::string iceParametersString = std::string([iceParameters UTF8String]);
        const std::string iceCandidatesString = std::string([iceCandidates UTF8String]);
        const std::string dtlsParametersString = std::string([dtlsParameters UTF8String]);
        mediasoupclient::PeerConnection::Options* pcOptions = reinterpret_cast<mediasoupclient::PeerConnection::Options *>(options);
        std::cout << "nativeCreateSendTransport 2" << std::endl;
        
        nlohmann::json appDataJson = nlohmann::json::object();
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        mediasoupclient::SendTransport *transport = reinterpret_cast<mediasoupclient::Device *>(nativeDevice)->CreateSendTransport(transportListener, idString, nlohmann::json::parse(iceParametersString), nlohmann::json::parse(iceCandidatesString), nlohmann::json::parse(dtlsParametersString), pcOptions, appDataJson);
        
        std::cout << "SendTransport created id=" << transport->GetId() << std::endl;
        //return reinterpret_cast<NSObject *>(transport);
        return [NSValue valueWithPointer:transport];
    } catch(std::exception &e) {
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
    
    return nullptr;
}

+(NSValue *)nativeCreateRecvTransport:(NSObject *)nativeDevice listener:(Protocol<RecvTransportListener> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
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
        
        mediasoupclient::RecvTransport *transport = reinterpret_cast<mediasoupclient::Device *>(nativeDevice)->CreateRecvTransport(transportListener, idString, nlohmann::json::parse(iceParametersString), nlohmann::json::parse(iceCandidatesString), nlohmann::json::parse(dtlsParametersString), pcOptions, appDataJson);
        
        //return reinterpret_cast<NSObject *>(transport);
        return [NSValue valueWithPointer:transport];
    } catch (std::exception &e) {
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
    
    return nullptr;
}

@end
