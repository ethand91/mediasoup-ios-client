//
//  Parameters.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/11/29.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef Parameters_h
#define Parameters_h

@interface Parameters: NSObject {}
+(NSString *)generateRouterRtpCapabilities;
+(NSString *)generateRouterRtpCapabilities:(bool)includeVideo includeAudio:(bool)includeAudio;
+(NSDictionary *)generateTransportRemoteParameters;
+(NSString *)generateIceServers;
@end


#endif /* Parameters_h */
