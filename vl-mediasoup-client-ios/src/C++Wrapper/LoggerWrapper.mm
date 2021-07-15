//
//  LoggerWrapper.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Logger.hpp"

using namespace mediasoupclient;

@implementation LoggerWrapper : NSObject

+(void)nativeSetLogLevel:(int)logLevel {
    Logger::SetLogLevel(static_cast<Logger::LogLevel>(logLevel));
}

+(void)nativeSetDefaultHandler {
    Logger::SetDefaultHandler();
}

@end
