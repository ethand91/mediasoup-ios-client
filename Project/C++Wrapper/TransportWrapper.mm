#import <Foundation/Foundation.h>

#import "Transport.hpp"

@interface TransportWrapper : NSObject
@property(nonatomic, readonly)NSString *id;
@property(nonatomic, readonly)NSObject *iceParameters;
@property(nonatomic, readonly)NSObject *iceCandidates;
@property(nonatomic, readonly)NSObject *dtlsParameters;
@property(nonatomic, readonly)NSObject *peerConnectionOptions;
@property(nonatomic, readonly)NSObject *extendedRtpCapabilities;
@property(nonatomic, readonly)NSObject *canProduceByKind;
@property(nonatomic, readonly)NSObject *appData;
@end

@interface TransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::Transport *transport;
@end

@implementation TransportWrapper
@synthesize transport = _transport;

-(NSString *)getNativeId {
    return [NSString stringWithUTF8String:self.transport->GetId().c_str()];
}

-(NSString *)getNativeConnectionState {
    return [NSString stringWithUTF8String:self.transport->GetConnectionState().c_str()];
}

-(NSString *)getNativeAppData {
    std::string appDataString = self.transport->GetAppData().dump();
    return [NSString stringWithUTF8String:appDataString.c_str()];
}

-(NSString *)getNativeStats {
    std::string statsString = self.transport->GetStats().dump();
    return [NSString stringWithUTF8String:statsString.c_str()];
}

-(Boolean *)getNativeClosed {
    return (Boolean *)self.transport->IsClosed();
}

-(void)nativeRestartIce:(NSString *)iceParameters {
    nlohmann::json iceParametersJson = nlohmann::json::parse(std::string([iceParameters UTF8String]));
    self.transport->RestartIce(iceParametersJson);
}

-(void)nativeUpdateIceServers:(NSString *)iceServers {
    nlohmann::json iceServersJson = nlohmann::json::parse(std::string([iceServers UTF8String]));
    self.transport->UpdateIceServers(iceServersJson);
}

-(void)nativeClose {
    self.transport->Close();
}

// TODO::
-(void)nativeProduce:(NSObject *)track encodings:(NSString *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    
}

@end
