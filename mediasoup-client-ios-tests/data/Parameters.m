#import "Parameters.h"

@implementation Parameters

+ (NSString *)generateRouterRtpCapabilities {
    return @"{}";
}

+ (NSString *)generateRouterRtpCapabilities:(bool)includeVideo includeAudio:(bool)includeAudio {
    return @"{}";
}

+ (NSDictionary *)generateTransportRemoteParameters {
    return @{ @"id": @"TRANSPORT_ID",
              @"dtlsParameters": @{},
              @"iceCandidates": @[],
              @"iceParameters": @{} };
}

@end
