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

@end

/*
-(void)nativeLoad:(NSString *)routerRtpCapabilities {
    nlohmann::json routerRtpCapabilitiesJson = nlohmann::json::parse(std::string([routerRtpCapabilities UTF8String]));
    self.device->Load(routerRtpCapabilitiesJson);
}

-(Boolean *)nativeIsLoaded {
    return (Boolean *)self.device->IsLoaded();
}

-(NSString *)nativeGetRtpCapabilities {
    std::string rtpCapabilitiesString = self.device->GetRtpCapabilities().dump();
    return [NSString stringWithUTF8String:rtpCapabilitiesString.c_str()];
}

-(Boolean *)nativeCanProduce:(NSString *)kind {
    return (Boolean *)self.device->CanProduce(std::string([kind UTF8String]));
}

-(SendTransportWrapper *)nativeCreateSendTransport:(Protocol<SendTransportListenerWrapper> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(NSString *)options appData:(NSString *)appData {
    
    try {
        auto transportListener = new SendTransportListener(listener);
        std::string idString = std::string([id UTF8String]);
        nlohmann::json iceParametersJson = nlohmann::json::parse(std::string([iceParameters UTF8String]));
        nlohmann::json iceCandidatesJson = nlohmann::json::parse(std::string([iceCandidates UTF8String]));
        nlohmann::json dtlsParametersJson = nlohmann::json::parse(std::string([dtlsParameters UTF8String]));
        
        nlohmann::json appDataJson = nlohmann::json::object();
        
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        // TODO: options
        mediasoupclient::SendTransport *sendTransport = self.device->CreateSendTransport(transportListener, idString, iceParametersJson, iceCandidatesJson, dtlsParametersJson, nullptr, appDataJson);
        
        SendTransportWrapper *sendTransportWrapper = [[SendTransportWrapper alloc] initWithSendTransport:sendTransport];
        
        return sendTransportWrapper;
    } catch (std::exception &e) {
        return nullptr;
    }
}

-(RecvTransportWrapper *)nativeCreateRecvTransport:(Protocol<TransportListenerWrapper> *)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(NSString *)options appData:(NSString *)appData {
    
    try {
        auto transportListener = new RecvTransportListener(listener);
        std::string idString = std::string([id UTF8String]);
        nlohmann::json iceParametersJson = nlohmann::json::parse(std::string([iceParameters UTF8String]));
        nlohmann::json iceCandidatesJson = nlohmann::json::parse(std::string([iceCandidates UTF8String]));
        nlohmann::json dtlsParametersJson = nlohmann::json::parse(std::string([dtlsParameters UTF8String]));
        
        nlohmann::json appDataJson = nlohmann::json::object();
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        // TODO: options
        mediasoupclient::RecvTransport *recvTransport = self.device->CreateRecvTransport(transportListener, idString, iceParametersJson, iceCandidatesJson, dtlsParametersJson, nullptr, appDataJson);
        
        RecvTransportWrapper *recvTransportWrapper = [[RecvTransportWrapper alloc] initWithRecvTransport:recvTransport];
        
        return recvTransportWrapper;
    } catch(const std::exception &e) {
        return nullptr;
    }
}
*/
