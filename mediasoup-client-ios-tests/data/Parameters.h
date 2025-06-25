#import <Foundation/Foundation.h>

@interface Parameters : NSObject
+ (NSString *)generateRouterRtpCapabilities;
+ (NSString *)generateRouterRtpCapabilities:(bool)includeVideo includeAudio:(bool)includeAudio;
+ (NSDictionary *)generateTransportRemoteParameters;
@end
