#import "Logger.h"
#import "LoggerWrapper.h"

@implementation Logger : NSObject

+(void)setDefaultHandler {
    [LoggerWrapper nativeSetDefaultHandler];
}

+(void)setLogLevel:(LogLevel)level {
    [LoggerWrapper nativeSetLogLevel:level];
}

@end
