#import "include/MediasoupclientWrapper.h"

@implementation MediasoupclientWrapper

+(NSString *)nativeVersion {
    std::string version = mediasoupclient::Version();
    
    return [NSString stringWithUTF8String:version.c_str()];
}

@end
