//
//  TransportWrapper.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#define MSC_CLASS "transport_wrapper"

#import <Foundation/Foundation.h>
#import <WebRTC/RTCMediaStreamTrack.h>
#import <WebRTC/RTCRtpEncodingParameters.h>
#import "Logger.hpp"
#import "wrapper/TransportWrapper.h"

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

+(::Producer *)nativeProduce:(NSValue *)nativeTransport listener:(id<ProducerListener>)listener
    pcFactory:(RTCPeerConnectionFactory *)pcFactory track:(NSUInteger)mediaTrack
    encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {

    MSC_TRACE();
    
    try {
        auto producerListener = new ProducerListenerWrapper(listener);
        auto mediaStreamTrack = reinterpret_cast<webrtc::MediaStreamTrackInterface *>(mediaTrack);
        
        __block std::vector<webrtc::RtpEncodingParameters> encodingsVector;
        
        if(encodings != nullptr) {
            encodingsVector.reserve(encodings.count);
            
            // Build the equvilent c++ encoding from objective-c encoding
            for (RTCRtpEncodingParameters *encoding in encodings) {
                webrtc::RtpEncodingParameters nativeEncoding;
                nativeEncoding.active = encoding.isActive;
                
                if (encoding.maxBitrateBps != nil) nativeEncoding.max_bitrate_bps = absl::make_optional(encoding.maxBitrateBps.intValue);
                if (encoding.minBitrateBps != nil) nativeEncoding.min_bitrate_bps = absl::make_optional(encoding.minBitrateBps.intValue);
                if (encoding.maxFramerate != nil) nativeEncoding.max_framerate = absl::make_optional(encoding.maxFramerate.doubleValue);
                if (encoding.numTemporalLayers != nil) nativeEncoding.num_temporal_layers = absl::make_optional(encoding.numTemporalLayers.intValue);
                if (encoding.scaleResolutionDownBy != nil) nativeEncoding.scale_resolution_down_by = absl::make_optional(encoding.scaleResolutionDownBy.doubleValue);
                
                encodingsVector.emplace_back(nativeEncoding);
            }
        }
        
        nlohmann::json codecOptionsJson = nlohmann::json::object();
        
        if (codecOptions != nullptr) {
            codecOptionsJson = nlohmann::json::parse(std::string([codecOptions UTF8String]));
        }
        
        nlohmann::json appDataJson = nlohmann::json::object();
        
        if (appData != nullptr) {
            appDataJson = nlohmann::json::parse(std::string([appData UTF8String]));
        }

        auto const ownedTransport = reinterpret_cast<OwnedSendTransport *>([nativeTransport pointerValue]);
        auto const transport = ownedTransport->transport();

        mediasoupclient::Producer *nativeProducer;
        
        // Prevent sdp error when called at the same time on multiple threads (a=mid)
        @synchronized (self) {
            nativeProducer = transport->Produce(producerListener, mediaStreamTrack, &encodingsVector, &codecOptionsJson, appDataJson);
        }

        auto ownedProducer = new OwnedProducer(nativeProducer, producerListener);
        auto pOwnedProducer = [NSValue valueWithPointer:ownedProducer];
        ::Producer *producer = [[::Producer alloc] initWithNativeProducer:pOwnedProducer pcFactory:pcFactory];

        producerListener->SetProducer(producer);
        
        return producer;
    } catch (std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];

        @throw exception;
    }
}

+(::Consumer *)nativeConsume:(NSValue *)nativeTransport  listener:(id<ConsumerListener>)listener
    pcFactory:(RTCPeerConnectionFactory *)pcFactory id:(NSString *)id
    producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters
    appData:(NSString *)appData {

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

        auto const ownedTransport = reinterpret_cast<OwnedRecvTransport *>([nativeTransport pointerValue]);
        auto const transport = ownedTransport->transport();

        mediasoupclient::Consumer *nativeConsumer;
        
        @synchronized(self) {
            nativeConsumer = transport->Consume(consumerListener, idString, producerIdString, kindString, &rtpParametersJson, appDataJson);
        }

        auto ownedConsumer = new OwnedConsumer(nativeConsumer, consumerListener);
        auto pOwnedConsumer = [NSValue valueWithPointer:ownedConsumer];
        ::Consumer *consumer = [[::Consumer alloc] initWithNativeConsumer:pOwnedConsumer pcFactory:pcFactory];
        consumerListener->SetConsumer(consumer);
        
        return consumer;
    } catch (std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        @throw exception;
    }
}

+(mediasoupclient::Transport *)extractNativeTransport:(NSValue *)nativeTransport {
    auto const ownedTransport = reinterpret_cast<OwnedTransport *>([nativeTransport pointerValue]);
    auto const transport = ownedTransport->transport();

    MSC_ASSERT(transport != nullptr, "native transport pointer null");
    
    return transport;
}

+(void)nativeFreeSendTransport:(NSValue *)nativeTransport {
    auto transport = reinterpret_cast<OwnedSendTransport *>([nativeTransport pointerValue]);
    delete transport;
}

+(void)nativeFreeRecvTransport:(NSValue *)nativeTransport {
    auto transport = reinterpret_cast<OwnedRecvTransport *>([nativeTransport pointerValue]);
    delete transport;
}

@end
