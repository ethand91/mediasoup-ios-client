//
//  DataConsumerWrapper.mm
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#define MSC_CLASS "dataconsumer_wrapper"

#import <Foundation/Foundation.h>
#import "DataConsumer.hpp"
#import "Logger.hpp"

#import "wrapper/DataConsumerWrapper.h"

using namespace mediasoupclient;

@implementation DataConsumerWrapper : NSObject

+(NSString *)getNativeId:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const std::string nativeId = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeDataProducerId:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const std::string nativeId = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetDataProducerId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeSctpStreamParameters:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const std::string nativeSctpStreamParameters = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetSctpStreamParameters().dump();
    
    return [NSString stringWithUTF8String:nativeSctpStreamParameters.c_str()];
}

+(NSString *)getNativeReadyState:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const webrtc::DataChannelInterface::DataState nativeReadyState = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetReadyState();
    
    return [NSString stringWithCString:webrtc::DataChannelInterface::DataStateString(nativeReadyState) encoding:NSASCIIStringEncoding];
}

+(NSString *)getNativeLabel:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const std::string nativeLabel = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetLabel();
    
    return [NSString stringWithUTF8String:nativeLabel.c_str()];
}

+(NSString *)getNativeProtocol:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const std::string nativeProtocol = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetProtocol();
    
    return [NSString stringWithUTF8String:nativeProtocol.c_str()];
}

+(NSString *)getNativeAppData:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    const std::string nativeAppData = reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->GetAppData().dump();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(bool)isNativeClosed:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    return reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->IsClosed();
}

+(void)nativeClose:(NSValue *)nativeConsumer {
    MSC_TRACE();
    
    reinterpret_cast<OwnedDataConsumer *>([nativeConsumer pointerValue])->consumer()->Close();
}

@end
