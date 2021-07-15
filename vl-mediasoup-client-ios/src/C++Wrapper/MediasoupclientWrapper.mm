//
//  MediasoupclientWrapper.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <WebRTC/RTCPeerConnectionFactory.h>

#import "wrapper/MediasoupclientWrapper.h"

@implementation MediasoupclientWrapper

+(NSString *)nativeVersion {
    std::string version = mediasoupclient::Version();
    
    return [NSString stringWithUTF8String:version.c_str()];
}

@end
