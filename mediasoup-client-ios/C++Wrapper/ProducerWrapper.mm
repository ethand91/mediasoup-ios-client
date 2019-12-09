#define MSC_CLASS "producer_wrapper"

#import <Foundation/Foundation.h>

#import "Producer.hpp"
#import "Logger.hpp"
#import "include/ProducerWrapper.h"

using namespace mediasoupclient;

@implementation ProducerWrapper : NSObject

+(NSString *)getNativeId:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeId = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(bool)isNativeClosed:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->IsClosed();
}

+(NSString *)getNativeKind:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeKind = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetKind();
    
    return [NSString stringWithUTF8String:nativeKind.c_str()];
}

+(webrtc::MediaStreamTrackInterface *)getNativeTrack:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    auto mediaStreamTrack = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetTrack();
    
    return mediaStreamTrack;
}

+(bool)isNativePaused:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->IsPaused();
}

+(int)getNativeMaxSpatialLayer:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    auto maxSpatialLayer = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetMaxSpatialLayer();
    
    return maxSpatialLayer;
}

+(NSString *)getNativeAppData:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeAppData = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetAppData();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(NSString *)getNativeRtpParameters:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeRtpParameters = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetRtpParameters();
    
    return [NSString stringWithUTF8String:nativeRtpParameters.c_str()];
}

+(NSString *)getNativeStats:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    try {
        const std::string nativeStats = reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
        
        return nullptr;
    }
}

+(void)nativeResume:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->Resume();
}

+(void)nativePause:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->Pause();
}

+(void)setNativeMaxSpatialLayer:(NSValue *)nativeProducer layer:(int)layer {
    MSC_TRACE();
    
    try {
        reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->SetMaxSpatialLayer(layer);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeReplaceTrack:(NSValue *)nativeProducer track:(NSUInteger *)track {
    MSC_TRACE();
    
    try {
        auto mediaStreamTrack = reinterpret_cast<webrtc::MediaStreamTrackInterface *>(track);
        reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->ReplaceTrack(mediaStreamTrack);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeClose:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<OwnedProducer *>([nativeProducer pointerValue])->producer()->Close();
}

@end
