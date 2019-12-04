#include <iostream>
#import <Foundation/Foundation.h>
#import "SendTransport.h"
#import "TransportWrapper.h"
#import "Producer.h"

@implementation SendTransport : Transport

-(instancetype)initWithNativeTransport:(NSObject *)nativeTransport {
    self = [super init];
    if (self) {
        self._nativeTransport = nativeTransport;
    }
    
    return self;
}

-(void)dispose {
    [self checkTransportExists];
    
    [TransportWrapper nativeFreeTransport:self._nativeTransport];
}

-(Producer *)produce:(Protocol<ProducerListener> *)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions {
    std::cout << "produce 0" << std::endl;
    return [self produce:listener track:track encodings:encodings codecOptions:codecOptions appData:nil];
}

-(Producer *)produce:(Protocol<ProducerListener> *)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    std::cout << "produce 1" << std::endl;
    NSLog(@"TESTING TRACK %@", track);
    NSValue *producerObject = [TransportWrapper nativeProduce:self._nativeTransport listener:listener track:track encodings:encodings codecOptions:codecOptions appData:appData];
    Producer *producer = [[Producer alloc] initWithNativeProducer:producerObject];
    std::cout << "produce 2" << std::endl;
    
    return producer;
}

-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
