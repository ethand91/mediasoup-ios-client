#include <iostream>
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
