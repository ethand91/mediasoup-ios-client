//
//  MediasoupclientWrapper.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "include/MediasoupclientWrapper.h"
#import <WebRTC/RTCPeerConnectionFactory.h>

@implementation MediasoupclientWrapper

+(NSString *)nativeVersion {
    std::string version = mediasoupclient::Version();
    
    return [NSString stringWithUTF8String:version.c_str()];
}

+(void)nativeInitialize {
    [RTCPeerConnectionFactory initialize];
    mediasoupclient::Initialize();
}

+(void)nativeCleanup {
    mediasoupclient::Cleanup();
}

@end
