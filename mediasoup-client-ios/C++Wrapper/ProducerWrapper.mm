#define MSC_CLASS "producer_wrapper"

#import <Foundation/Foundation.h>

#import "Producer.hpp"
#import "Logger.hpp"
#import "include/ProducerWrapper.h"

using namespace mediasoupclient;

@implementation ProducerWrapper : NSObject

+(NSString *)getNativeId:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeId = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(bool)isNativeClosed:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    return reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->IsClosed();
}

+(NSString *)getNativeKind:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeKind = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetKind();
    
    return [NSString stringWithUTF8String:nativeKind.c_str()];
}

+(NSValue *)getNativeTrack:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    auto mediaStreamTrack = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetTrack();
    
    return reinterpret_cast<NSObject *>(mediaStreamTrack);
}

+(bool)isNativePaused:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    return reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->IsPaused();
}

+(int)getNativeMaxSpatialLayer:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    auto maxSpatialLayer = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetMaxSpatialLayer();
    
    return maxSpatialLayer;
}

+(NSString *)getNativeAppData:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeAppData = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetAppData();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(NSString *)getNativeRtpParameters:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeRtpParameters = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetRtpParameters();
    
    return [NSString stringWithUTF8String:nativeRtpParameters.c_str()];
}

+(NSString *)getNativeStats:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    try {
        const std::string nativeStats = reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch (const std::exception &e) {
        //TODO
        return nullptr;
    }
}

+(void)nativeResume:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->Resume();
}

+(void)nativePause:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->Pause();
}

+(void)setNativeMaxSpatialLayer:(NSValue *)nativeProducer layer:(int)layer {
    MSC_TRACE();
    
    try {
        reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->SetMaxSpatialLayer(layer);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeReplaceTrack:(NSValue *)nativeProducer track:(NSValue *)track {
    MSC_TRACE();
    
    try {
        auto mediaStreamTrack = reinterpret_cast<webrtc::MediaStreamTrackInterface *>([track pointerValue]);
        reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->ReplaceTrack(mediaStreamTrack);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeClose:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<mediasoupclient::Producer *>([nativeProducer pointerValue])->Close();
}

@end
