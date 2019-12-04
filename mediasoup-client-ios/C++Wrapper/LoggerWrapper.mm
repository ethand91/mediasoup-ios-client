#include <iostream>
#import <Foundation/Foundation.h>

#import "Logger.hpp"

using namespace mediasoupclient;

class DefaultLogHandler : public Logger::LogHandlerInterface {
public:
    void OnLog(Logger::LogLevel level, char *payload, size_t len) override {
        std::cout << payload <<std::endl;
    }
};

@implementation LoggerWrapper : NSObject

+(void)nativeSetLogLevel:(int)logLevel {
    std::cout << "setLogLevel" << std::endl;
    Logger::SetLogLevel(static_cast<Logger::LogLevel>(logLevel));
}

+(void)nativeSetDefaultHandler {
    std::cout << "setDefaultHandler" << std::endl;
    Logger::SetDefaultHandler();
}

@end
