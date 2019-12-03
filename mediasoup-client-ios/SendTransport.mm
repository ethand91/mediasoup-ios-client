#import <Foundation/Foundation.h>
#import "SendTransport.h"
#import "TransportWrapper.h"

@implementation SendTransport : Transport

-(id)initWithNativeTransport:(NSObject *)nativeTransport {
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
    return [self produce:listener track:track encodings:encodings codecOptions:codecOptions appData:nil];
}

-(Producer *)produce:(Protocol<ProducerListener> *)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    return [TransportWrapper nativeProduce:self._nativeTransport listener:listener track:track encodings:encodings codecOptions:codecOptions appData:appData];
}

-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
