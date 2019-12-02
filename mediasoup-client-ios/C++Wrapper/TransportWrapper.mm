#import <Foundation/Foundation.h>

#import "include/TransportWrapper.h"

@implementation TransportWrapper : NSObject

+(NSString *)getNativeId:(NSObject *)nativeTransport {
    const std::string nativeId = reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeConnectionState:(NSObject *)nativeTransport {
    const std::string nativeConnectionState = reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->GetConnectionState();
    
    return [NSString stringWithUTF8String:nativeConnectionState.c_str()];
}

+(NSString *)getNativeAppData:(NSObject *)nativeTransport {
    const std::string nativeAppData = reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->GetAppData().dump();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(NSString *)getNativeStats:(NSObject *)nativeTransport {
    try {
        const std::string nativeStats = reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch(const std::exception &e) {
        // TODO log
        return nullptr;
    }
}

+(bool)isNativeClosed:(NSObject *)nativeTransport {
    return reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->IsClosed();
}

+(void)nativeRestartIce:(NSObject *)nativeTransport iceParameters:(NSString *)iceParameters {
    try {
        nlohmann::json iceParametersJson = nlohmann::json::object();
        
        if (iceParameters != nullptr) {
            iceParametersJson = nlohmann::json::parse(std::string([iceParameters UTF8String]));
        }
        
        reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->RestartIce(iceParametersJson);
    } catch (const std::exception &e) {
        //TODO
    }
}

+(void)nativeUpdateIceServers:(NSObject *)nativeTransport iceServers:(NSString *)iceServers {
    try {
        auto iceServersJson = nlohmann::json::array();
        
        if (iceServers != nullptr) {
            iceServersJson = nlohmann::json::parse(std::string([iceServers UTF8String]));
        }
        
        reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->UpdateIceServers(iceServersJson);
    } catch (const std::exception &e) {
        // TODO
    }
}

+(void)nativeClose:(NSObject *)nativeTransport {
    reinterpret_cast<mediasoupclient::Transport *>(nativeTransport)->Close();
}

+(NSObject *)nativeGetNativeTransport:(NSObject *)nativeTransport {
    return reinterpret_cast<NSObject *>(nativeTransport);
}

+(NSObject *)nativeProduce:(NSObject *)nativeTransport listener:(Protocol<ProducerListenerWrapper> *)listener track:(NSObject *)track encodings:(NSString *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    try {
        auto producerListener = new ProducerListenerWrapperImpl(listener);
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
        
        mediasoupclient::SendTransport *transport = reinterpret_cast<mediasoupclient::SendTransport *>(nativeTransport);
        mediasoupclient::Producer *producer = transport->Produce(producerListener, mediaTrack, &encodingsVector, &codecOptionsJson, appDataJson);
        
        return reinterpret_cast<NSObject *>(producer);
    } catch (std::exception &e) {
        // TODO
        return nullptr;
    }
}

+(NSObject *)nativeConsume:(NSObject *)nativeTransport listener:(Protocol<ConsumerListenerWrapper> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    try {
        auto consumerListener = new ConsumerListenerWrapperImpl(listener);
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
        
        mediasoupclient::RecvTransport *transport = reinterpret_cast<mediasoupclient::RecvTransport *>(nativeTransport);
        mediasoupclient::Consumer *consumer = transport->Consume(consumerListener, idString, producerIdString, kindString, &rtpParametersJson, appDataJson);
        
        return reinterpret_cast<NSObject *>(consumer);
    } catch (std::exception &e) {
        // TODO
        return nullptr;
    }
}

@end
