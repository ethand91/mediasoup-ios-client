#import "Mediasoupclient.h"
#import "MediasoupclientWrapper.h"

@implementation Mediasoupclient
+(NSString *)version {
    return [MediasoupclientWrapper nativeVersion];
}
@end
