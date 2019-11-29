#import <Foundation/Foundation.h>

#include "Transport.hpp"
#include "include/TransportWrapper.h"
#include "include/ProducerWrapper.h"

@implementation SendTransportWrapper
@synthesize sendTransport = _sendTransport;
@synthesize listener = _listener;

-(instancetype)initWithSendTransport:(mediasoupclient::SendTransport *)sendTransport {
    self = [super init];
    if(self) {
        _sendTransport = sendTransport;
    }

    return self;
}

-(std::future<std::string>)onProduce:(mediasoupclient::Transport *)transport kind:(std::string &)kind rtpParameters:(nlohmann::json)rtpParameters appData:(nlohmann::json &)appData {
    std::string rtpParametersString = rtpParameters.dump();
    std::string appDataString = appData.dump();
    
    NSString *producerId = [self.listener
                            onProduce:(NSObject *)self.transport
                            kind:[NSString stringWithUTF8String:kind.c_str()]
                            rtpParameters:[NSString stringWithUTF8String:rtpParametersString.c_str()]
                            appData:[NSString stringWithUTF8String:appDataString.c_str()]];
    
    std::promise<std::string> promise;
    promise.set_value(std::string([producerId UTF8String]));
    
    return promise.get_future();
}

-(ProducerWrapper *)nativeProduce:(Protocol<ProducerListenerWrapper> *)listener track:(NSObject *)track encodings:(NSString *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    auto mediaStreamTrack = (__bridge webrtc::MediaStreamTrackInterface *) track;
    const std::vector<webrtc::RtpEncodingParameters> encodingsVector;
    auto producerListener = new ProducerListener(listener);
    
    // TODO
    if (encodings != nullptr) {
    }
    
    nlohmann::json codecOptionsJson = nlohmann::json::object();
    if (codecOptions != nullptr) {
        codecOptionsJson = nlohmann::json::parse(std::string([codecOptions UTF8String]));
    }
    
    nlohmann::json appDataJson = nlohmann::json::object();
    if (appData != nullptr) {
        appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
    }
    
    mediasoupclient::Producer *originProducer = self.sendTransport->Produce(producerListener, mediaStreamTrack, &encodingsVector, &codecOptionsJson, appDataJson);
    
    ProducerWrapper *producer = [[ProducerWrapper alloc] initWithProducer:originProducer];
    
    return producer;
}

@end
