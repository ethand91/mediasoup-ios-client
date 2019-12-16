//
//  ConsumerWrapper.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#define MSC_CLASS "consumer_wrapper"

#import <Foundation/Foundation.h>
#import <libmediasoupclient/include/Logger.hpp>
#import <libmediasoupclient/include/Consumer.hpp>

#import "include/ConsumerWrapper.h"

using namespace mediasoupclient;

@implementation ConsumerWrapper : NSObject

+(NSString *)getNativeId:(NSValue *)nativeConsumer {
    MSC_TRACE();
    const std::string nativeId = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeProducerId:(NSValue *)nativeConsumer {
    MSC_TRACE();
    const std::string nativeProducerId = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetProducerId();
    
    return [NSString stringWithUTF8String:nativeProducerId.c_str()];
}

+(bool)isNativeClosed:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->IsClosed();
}

+(bool)isNativePaused:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->IsPaused();
}

+(NSString *)getNativeKind:(NSValue *)nativeConsumer {
    MSC_TRACE();
    const std::string nativeKind = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetKind();
    
    return [NSString stringWithUTF8String:nativeKind.c_str()];
}

+(webrtc::MediaStreamTrackInterface *)getNativeTrack:(NSValue *)nativeConsumer {
    MSC_TRACE();
    auto mediaStreamTrack = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetTrack();
    
    return mediaStreamTrack;
}

+(NSString *)getNativeRtpParameters:(NSValue *)nativeConsumer {
    MSC_TRACE();
    const std::string nativeRtpParameters = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetRtpParameters().dump();
    
    return [NSString stringWithUTF8String:nativeRtpParameters.c_str()];
}

+(NSString *)getNativeAppData:(NSValue *)nativeConsumer {
    MSC_TRACE();
    const std::string nativeAppData = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetAppData().dump();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(void)nativeResume:(NSValue *)nativeConsumer {
    MSC_TRACE();
    reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->Resume();
}

+(void)nativePause:(NSValue *)nativeConsumer {
    MSC_TRACE();
    reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->Pause();
}

+(NSString *)getNativeStats:(NSValue *)nativeConsumer {
    MSC_TRACE();
    try {
        const std::string nativeStats = reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
        
        return nullptr;
    }
}

+(void)nativeClose:(NSValue *)nativeConsumer {
    MSC_TRACE();
    reinterpret_cast<OwnedConsumer *>([nativeConsumer pointerValue])->consumer()->Close();
}

@end
