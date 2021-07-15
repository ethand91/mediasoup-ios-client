//
//  Logger.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MediasoupLogger.h"
#import "LoggerWrapper.h"

@implementation MediasoupLogger : NSObject

+(void)setDefaultHandler {
    [LoggerWrapper nativeSetDefaultHandler];
}

+(void)setLogLevel:(LogLevel)level {
    [LoggerWrapper nativeSetLogLevel:level];
}

@end
