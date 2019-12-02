//
//  Consumer.m
//  Project
//
//  Created by Denvir Ethan on 2019/11/22.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Consumer.hpp"
#import "include/ConsumerWrapper.h"

@implementation ConsumerWrapper : NSObject

+(NSString *)getNativeId:(NSObject *)nativeConsumer {
    const std::string nativeId = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetId();
    
    return [NSString stringWithUTF8String:nativeId.c_str()];
}

+(NSString *)getNativeProducerId:(NSObject *)nativeConsumer {
    const std::string nativeProducerId = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetProducerId();
    
    return [NSString stringWithUTF8String:nativeProducerId.c_str()];
}

+(bool)isNativeClosed:(NSObject *)nativeConsumer {
    return reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->IsClosed();
}

+(bool)isNativePaused:(NSObject *)nativeConsumer {
    return reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->IsPaused();
}

+(NSString *)getNativeKind:(NSObject *)nativeConsumer {
    const std::string nativeKind = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetKind();
    
    return [NSString stringWithUTF8String:nativeKind.c_str()];
}

+(NSObject *)getNativeTrack:(NSObject *)nativeConsumer {
    auto mediaStreamTrack = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetTrack();
    
    return reinterpret_cast<NSObject *>(mediaStreamTrack);
}

+(NSString *)getNativeRtpParameters:(NSObject *)nativeConsumer {
    const std::string nativeRtpParameters = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetRtpParameters().dump();
    
    return [NSString stringWithUTF8String:nativeRtpParameters.c_str()];
}

+(NSString *)getNativeAppData:(NSObject *)nativeConsumer {
    const std::string nativeAppData = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetAppData().dump();
    
    return [NSString stringWithUTF8String:nativeAppData.c_str()];
}

+(void)nativeResume:(NSObject *)nativeConsumer {
    reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->Resume();
}

+(void)nativePause:(NSObject *)nativeConsumer {
    reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->Pause();
}

+(NSString *)getNativeStats:(NSObject *)nativeConsumer {
    try {
        const std::string nativeStats = reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->GetStats().dump();
        
        return [NSString stringWithUTF8String:nativeStats.c_str()];
    } catch (const std::exception &e) {
        // TODO
        return nullptr;
    }
}

+(void)nativeClose:(NSObject *)nativeConsumer {
    reinterpret_cast<mediasoupclient::Consumer *>(nativeConsumer)->Close();
}

@end


/*
@implementation ConsumerWrapper
@synthesize consumer = _consumer;

-(void)onClose:(mediasoupclient::Consumer *)consumer {
    NSLog(@"Consumer Close");
}

-(instancetype) initWithConsumer:(mediasoupclient::Consumer *)consumer {
    self = [super init];
    if (self) {
        _consumer = consumer;
    }
    
    return self;
}

-(NSString *)getNativeId {
    return [NSString stringWithUTF8String:self.consumer->GetId().c_str()];
}

-(NSString *)getNativeProducerId {
    return [NSString stringWithUTF8String:self.consumer->GetProducerId().c_str()];
}

-(Boolean *)isNativeClosed {
    return (Boolean *)self.consumer->IsClosed();
}

-(Boolean *)isNativePaused {
    return (Boolean *)self.consumer->IsPaused();
}

-(NSString *)getNativeKind {
    return [NSString stringWithUTF8String:self.consumer->GetKind().c_str()];
}

-(NSObject *)getNativeTrack {
    return (NSObject *)CFBridgingRelease(self.consumer->GetTrack());
}

-(NSString *)getNativeRtpParameters {
    const std::string rtpParametersString = self.consumer->GetRtpParameters().dump();
    return [NSString stringWithUTF8String:rtpParametersString.c_str()];
}

-(NSString *)getNativeAppData {
    const std::string appDataString = self.consumer->GetAppData().dump();
    return [NSString stringWithUTF8String:appDataString.c_str()];
}

-(void)nativeResume {
    self.consumer->Resume();
}

-(void)nativePause {
    self.consumer->Pause();
}

-(NSString *)getNativeStats {
    const std::string statsString = self.consumer->GetStats().dump();
    return [NSString stringWithUTF8String:statsString.c_str()];
}

-(void)nativeClose {
    self.consumer->Close();
}

@end
 */
