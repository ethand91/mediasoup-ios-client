//
//  LoggerWrapper.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#ifndef LoggerWrapper_h
#define LoggerWrapper_h

@interface LoggerWrapper : NSObject {}
+(NSString *)nativeSetLogLevel:(int)logLevel;
+(void)nativeSetDefaultHandler;
@end

#endif /* LoggerWrapper_h */
