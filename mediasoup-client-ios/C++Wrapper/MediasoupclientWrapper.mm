#import "include/MediasoupclientWrapper.h"
#import "WebRTC/RTCPeerConnectionFactory.h"

@implementation MediasoupclientWrapper

+(NSString *)nativeVersion {
    std::string version = mediasoupclient::Version();
    
    return [NSString stringWithUTF8String:version.c_str()];
}

+(void)nativeInitialize {
    NSLog(@"InitializePC");
    [RTCPeerConnectionFactory initialize];
    mediasoupclient::Initialize();
}

+(void)nativeCleanup {
    mediasoupclient::Cleanup();
}

@end
