//
//  DataProducerWrapper.mm
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#define MSC_CLASS "dataproducer_wrapper"

#import <Foundation/Foundation.h>
#import "DataProducer.hpp"
#import "Logger.hpp"

#import "wrapper/DataProducerWrapper.h"

using namespace mediasoupclient;

@implementation DataProducerWrapper : NSObject

+(NSString *)getNativeId:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeId = reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeSctpStreamParameters:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeSctpStreamParameters = reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetSctpStreamParameters().dump();
    
    return [NSString stringWithUTF8String:nativeSctpStreamParameters.c_str()];
}

+(NSString *)getNativeReadyState:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const webrtc::DataChannelInterface::DataState nativeReadyState = reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetReadyState();
    
    return [NSString stringWithCString:webrtc::DataChannelInterface::DataStateString(nativeReadyState) encoding:NSASCIIStringEncoding];
}

+(NSString *)getNativeLabel:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeLabel = reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetLabel();
    
    return [NSString stringWithUTF8String:nativeLabel.c_str()];
}

+(NSString *)getNativeProtocol:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeProtocol = reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetProtocol();
    
    return [NSString stringWithUTF8String:nativeProtocol.c_str()];
}

+(uint64_t)getNativeBufferedAmount:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetBufferedAmount();
}

+(NSString *)getNativeAppData:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    const std::string nativeAppData = reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->GetAppData().dump();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(bool)isNativeClosed:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->IsClosed();
}

+(void)nativeSend:(NSValue *)nativeProducer buffer:(NSData *)buffer {
    MSC_TRACE();
    
    try {
        auto webRtcBuffer = webrtc::DataBuffer(std::string((const char *)buffer.bytes, buffer.length));
        reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->Send(webRtcBuffer);
    } catch (const std::exception &e) {
        MSC_ERROR("%s", e.what());
        NSString *message = [NSString stringWithUTF8String:e.what()];
        NSException* exception = [NSException exceptionWithName:@"RuntimeException" reason:message userInfo:nil];
        
        throw exception;
    }
}

+(void)nativeClose:(NSValue *)nativeProducer {
    MSC_TRACE();
    
    reinterpret_cast<OwnedDataProducer *>([nativeProducer pointerValue])->producer()->Close();
}

@end
