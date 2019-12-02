#import <Foundation/Foundation.h>

#import "Producer.hpp"
#import "include/ProducerWrapper.h"

@implementation ProducerWrapper : NSObject

+(NSString *)getNativeId:(NSObject *)nativeProducer {
    const std::string nativeId = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(bool)isNativeClosed:(NSObject *)nativeProducer {
    return reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->IsClosed();
}

+(NSString *)getNativeKind:(NSObject *)nativeProducer {
    const std::string nativeKind = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetKind();
    
    return [NSString stringWithUTF8String:nativeKind.c_str()];
}

+(NSObject *)getNativeTrack:(NSObject *)nativeProducer {
    auto mediaStreamTrack = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetTrack();
    
    return reinterpret_cast<NSObject *>(mediaStreamTrack);
}

+(bool)isNativePaused:(NSObject *)nativeProducer {
    return reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->IsPaused();
}

+(int)getNativeMaxSpatialLayer:(NSObject *)nativeProducer {
    auto maxSpatialLayer = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetMaxSpatialLayer();
    
    return maxSpatialLayer;
}

+(NSString *)getNativeAppData:(NSObject *)nativeProducer {
    const std::string nativeAppData = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetAppData();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(NSString *)getNativeRtpParameters:(NSObject *)nativeProducer {
    const std::string nativeRtpParameters = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetRtpParameters();
    
    return [NSString stringWithUTF8String:nativeRtpParameters.c_str()];
}

+(NSString *)getNativeStats:(NSObject *)nativeProducer {
    try {
        const std::string nativeStats = reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch (const std::exception &e) {
        //TODO
        return nullptr;
    }
}

+(void)nativeResume:(NSObject *)nativeProducer {
    reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->Resume();
}

+(void)nativePause:(NSObject *)nativeProducer {
    reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->Pause();
}

+(void)setNativeMaxSpatialLayer:(NSObject *)nativeProducer layer:(int)layer {
    try {
        reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->SetMaxSpatialLayer(layer);
    } catch (const std::exception &e) {
        // TODO
    }
}

+(void)nativeReplaceTrack:(NSObject *)nativeProducer track:(NSObject *)track {
    try {
        auto mediaStreamTrack = reinterpret_cast<webrtc::MediaStreamTrackInterface *>(track);
        reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->ReplaceTrack(mediaStreamTrack);
    } catch (const std::exception &e) {
        // TODO
    }
}

+(void)nativeClose:(NSObject *)nativeProducer {
    reinterpret_cast<mediasoupclient::Producer *>(nativeProducer)->Close();
}

@end
