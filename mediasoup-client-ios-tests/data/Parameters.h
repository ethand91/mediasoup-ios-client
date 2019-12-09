//
//  Parameters.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#ifndef Parameters_h
#define Parameters_h

@interface Parameters: NSObject {}
+(NSString *)generateRouterRtpCapabilities;
+(NSString *)generateRouterRtpCapabilities:(bool)includeVideo includeAudio:(bool)includeAudio;
+(NSDictionary *)generateTransportRemoteParameters;
+(NSString *)generateIceServers;
+(NSDictionary *)generateConsumerRemoteParameters;
@end


#endif /* Parameters_h */
