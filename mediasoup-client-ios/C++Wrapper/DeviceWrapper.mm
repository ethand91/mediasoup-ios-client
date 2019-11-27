#import <Foundation/Foundation.h>

#import "Device.hpp"
#import "Transport.hpp"
#import "include/Device.h"
#import "include/Transport.h"

@implementation DeviceWrapper
@synthesize device = _device;

- (id)init {
    self = [super init];
    if (self) {
        _device = new mediasoupclient::Device();
    }
    return self;
}

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

@end
