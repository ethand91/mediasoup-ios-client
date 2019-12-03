#define MSC_CLASS "transport_wrapper"

#import <Foundation/Foundation.h>
#import "Logger.hpp"

#import "include/TransportWrapper.h"

using namespace mediasoupclient;

@implementation TransportWrapper : NSObject

+(NSString *)getNativeId:(NSValue *)nativeTransport {
    MSC_TRACE();
    
    const std::string nativeId = [TransportWrapper extractNativeTransport:nativeTransport]->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeConnectionState:(NSValue *)nativeTransport {
    MSC_TRACE();
    
    const std::string nativeConnectionState = [TransportWrapper extractNativeTransport:nativeTransport]->GetConnectionState();
    
    return [NSString stringWithUTF8String:nativeConnectionState.c_str()];
}

+(NSString *)getNativeAppData:(NSValue *)nativeTransport {
    MSC_TRACE();
    
    const std::string nativeAppData = [TransportWrapper extractNativeTransport:nativeTransport]->GetAppData().dump();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(NSString *)getNativeStats:(NSValue *)nativeTransport {
    MSC_TRACE();
    
    try {
        const std::string nativeStats = [TransportWrapper extractNativeTransport:nativeTransport]->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch(const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
        
        return nullptr;
    }
}

+(bool)isNativeClosed:(NSValue *)nativeTransport {
    MSC_TRACE();
    
    return [TransportWrapper extractNativeTransport:nativeTransport]->IsClosed();
}

+(void)nativeRestartIce:(NSValue *)nativeTransport iceParameters:(NSString *)iceParameters {
    MSC_TRACE();
    
    try {
        nlohmann::json iceParametersJson = nlohmann::json::object();
        
        if (iceParameters != nullptr) {
            iceParametersJson = nlohmann::json::parse(std::string([iceParameters UTF8String]));
        }
        
        [TransportWrapper extractNativeTransport:nativeTransport]->RestartIce(iceParametersJson);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeUpdateIceServers:(NSValue *)nativeTransport iceServers:(NSString *)iceServers {
    MSC_TRACE();
    
    try {
        auto iceServersJson = nlohmann::json::array();
        
        if (iceServers != nullptr) {
            iceServersJson = nlohmann::json::parse(std::string([iceServers UTF8String]));
        }
        
        [TransportWrapper extractNativeTransport:nativeTransport]->UpdateIceServers(iceServersJson);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeClose:(NSValue *)nativeTransport {
    MSC_TRACE();
    
    [TransportWrapper extractNativeTransport:nativeTransport]->Close();
}

+(NSValue *)nativeGetNativeTransport:(NSValue *)nativeTransport {
    MSC_DEBUG();
    
    return [NSValue valueWithPointer:[TransportWrapper extractNativeTransport:nativeTransport]];
}

+(NSValue *)nativeProduce:(NSObject *)nativeTransport listener:(Protocol<ProducerListener> *)listener track:(NSObject *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    MSC_TRACE();
    
    try {
        auto producerListener = new ProducerListenerWrapper(listener);
        auto mediaTrack = reinterpret_cast<webrtc::MediaStreamTrackInterface *>(track);
        std::vector<webrtc::RtpEncodingParameters> encodingsVector;
        
        if(encodings != nullptr) {
            // TODO
        }
        
        nlohmann::json codecOptionsJson = nlohmann::json::object();
        
        if (codecOptions != nullptr) {
            codecOptionsJson = nlohmann::json::parse(std::string([codecOptions UTF8String]));
        }
        
        nlohmann::json appDataJson = nlohmann::json::object();
        
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        mediasoupclient::SendTransport *transport = reinterpret_cast<mediasoupclient::SendTransport *>([nativeTransport pointerValue]);
        mediasoupclient::Producer *producer = transport->Produce(producerListener, mediaTrack, &encodingsVector, &codecOptionsJson, appDataJson);
        
        return reinterpret_cast<NSObject *>(producer);
    } catch (std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
        
        return nullptr;
    }
}

+(NSObject *)nativeConsume:(NSValue *)nativeTransport listener:(Protocol<ConsumerListener> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    MSC_TRACE();
    
    try {
        auto consumerListener = new ConsumerListenerWrapper(listener);
        const std::string idString = std::string([id UTF8String]);
        const std::string producerIdString = std::string([producerId UTF8String]);
        const std::string kindString = std::string([kind UTF8String]);
        nlohmann::json rtpParametersJson = nlohmann::json::object();
        
        if (rtpParameters != nullptr) {
            rtpParametersJson = nlohmann::json::parse(std::string([rtpParameters UTF8String]));
        }
        
        nlohmann::json appDataJson = nlohmann::json::object();
        
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }
        
        mediasoupclient::RecvTransport *transport = reinterpret_cast<mediasoupclient::RecvTransport *>([nativeTransport pointerValue]);
        mediasoupclient::Consumer *consumer = transport->Consume(consumerListener, idString, producerIdString, kindString, &rtpParametersJson, appDataJson);
        
        return reinterpret_cast<NSObject *>(consumer);
    } catch (std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
        
        return nullptr;
    }
}

+(mediasoupclient::Transport *)extractNativeTransport:(NSValue *)nativeTransport {
    mediasoupclient::Transport *transport = reinterpret_cast<mediasoupclient::Transport *>([nativeTransport pointerValue]);
    MSC_ASSERT(transport != nullptr, "native transport pointer null");
    
    return transport;
}

@end
