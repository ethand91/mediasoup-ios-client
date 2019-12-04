//
//  LoggerWrapper.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/04.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef LoggerWrapper_h
#define LoggerWrapper_h

@interface LoggerWrapper : NSObject {}
+(NSString *)nativeSetLogLevel:(int)logLevel;
+(void)nativeSetDefaultHandler;
@end

#endif /* LoggerWrapper_h */
