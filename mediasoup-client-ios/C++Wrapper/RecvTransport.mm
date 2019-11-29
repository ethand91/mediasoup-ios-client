#import <Foundation/Foundation.h>

#include "Transport.hpp"
#include "include/TransportWrapper.h"
#include "include/ConsumerWrapper.h"

@implementation RecvTransportWrapper
@synthesize recvTransport = _recvTransport;

-(instancetype)initWithRecvTransport:(mediasoupclient::RecvTransport *)recvTransport {
    self = [super init];
    if(self) {
        _recvTransport = recvTransport;
    }
    
    return self;
}

-(ConsumerWrapper *)nativeConsume:(Protocol<ConsumerListenerWrapper> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    auto consumerListener = new ConsumerListener(listener);
    std::string consumerId = std::string([id UTF8String]);
    std::string producerIdString = std::string([producerId UTF8String]);
    std::string rtpParametersString = std::string([rtpParameters UTF8String]);
    std::string kindString = std::string([kind UTF8String]);
    
    nlohmann::json rtpParametersJson = nlohmann::json::object();
    if (rtpParameters != nullptr) {
        rtpParametersJson = nlohmann::json::parse(std::string([rtpParameters UTF8String]));
    }
    
    nlohmann::json appDataJson = nlohmann::json::object();
    if (appData != nullptr) {
        appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
    }
    
    mediasoupclient::Consumer *consumer = self.recvTransport->Consume(consumerListener, consumerId, producerIdString, kindString, &rtpParametersJson, appDataJson);
    
    ConsumerWrapper *consumerWrapper = [[ConsumerWrapper alloc] initWithConsumer:consumer];
    
    return consumerWrapper;
}

@end
