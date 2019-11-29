#import <Foundation/Foundation.h>

#import "Transport.hpp"
#import "include/TransportWrapper.h"

@implementation TransportWrapper
@synthesize transport = _transport;
@synthesize listener = _listener;

-(instancetype)initWithTransport:(mediasoupclient::Transport *)transport {
    self = [super init];
    if (self) {
        _transport = transport;
    }
    
    return self;
}

-(std::future<void>)onConnect:(mediasoupclient::Transport *)transport dtlsParameters:(nlohmann::json &)dtlsParameters {
    std::string dtlsParametersString = dtlsParameters.dump();
    
    [self.listener
             onConnect:(NSObject *)self.transport
             dtlsParameters:[NSString stringWithUTF8String:dtlsParametersString.c_str()]];
    
    std::promise<void> promise;
    promise.set_value();
    
    return promise.get_future();
}

-(void)onConnectionStateChange:(mediasoupclient::Transport *)transport connectionState:(std::string &)connectionState {
    // Check if listener is being listened to
    if([self.listener respondsToSelector:@selector(onConnectionStateChange:connectionState:)]) {
        [self.listener
                onConnectionStateChange:(NSObject *)self.transport
                connectionState:[NSString stringWithUTF8String:connectionState.c_str()]];
    }
}

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

@end
