//
//  Logger.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Logger_h
#define Logger_h

typedef NS_ENUM(int, LogLevel) {
    NONE = 0,
    ERROR = 1,
    WARN = 2,
    TRACE = 3,
};

@interface Logger : NSObject {}

/*!
    @brief Sets the log level of the libmediasoupclient
    @discussion This method sets the log level of libmediasoupclient valid values are (0 = log nothing, 1 = log errors, 2 = log warnings and above, 3 = log debug/traces and above)
    @param level The log level to set
 */
+(void)setLogLevel:(LogLevel)level;
/*!
    @brief Initializes the libmediasoupclient log
    @discussion Set the libmediasoupclient log, <b>this must be called before calling set log level</b>
 */
+(void)setDefaultHandler;

@end

#endif /* Logger_h */
