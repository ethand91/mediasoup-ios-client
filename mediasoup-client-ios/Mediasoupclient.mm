#import "Mediasoupclient.h"
#import "MediasoupclientWrapper.h"

@implementation Mediasoupclient
+(NSString *)version {
    return [MediasoupclientWrapper nativeVersion];
}

+(void)initialize {
    [MediasoupclientWrapper nativeInitialize];
}

+(void)cleanUp {
    [MediasoupclientWrapper nativeCleanup];
}
@end
