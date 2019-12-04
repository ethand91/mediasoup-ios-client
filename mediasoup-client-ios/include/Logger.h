//
//  Logger.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/04.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Logger_h
#define Logger_h

typedef NS_ENUM(int, LogLevel) {
    LOG_NONE = 0,
    LOG_ERROR = 1,
    LOG_WARN = 2,
    LOG_DEBUG = 3,
    LOG_TRACE = 4
};

@interface Logger : NSObject {}

+(void)setLogLevel:(LogLevel)level;
+(void)setDefaultHandler;

@end

#endif /* Logger_h */
