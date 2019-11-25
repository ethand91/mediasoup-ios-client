#import <Foundation/Foundation.h>

#import "Device.hpp"
#import "Transport.hpp"
#import "include/Device.h"

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

// TODO: Listener
-(NSObject *)nativeCreateSendTransport:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters options:(NSString *)options appData:(NSString *)appData {
    
    nlohmann::json iceParametersJson = nlohmann::json::parse(std::string([iceParameters UTF8String]));
    nlohmann::json iceCandidatesJson = nlohmann::json::parse(std::string([iceCandidates UTF8String]));
    nlohmann::json dtlsParametersJson = nlohmann::json::parse(std::string([dtlsParameters UTF8String]));
    
    nlohmann::json appDataJson = nlohmann::json::object();
    
    if (appData != nullptr) {
        appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
    }
    
}

@end
