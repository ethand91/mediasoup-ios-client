#import <Foundation/Foundation.h>
#import "RecvTransport.h"
#import "TransportWrapper.h"
#import "Consumer.h"

@implementation RecvTransport : Transport

-(instancetype)initWithNativeTransport:(NSObject *)nativeTransport {
    self = [super initWithNativeTransport:nativeTransport];
    if (self) {
        self._nativeTransport = nativeTransport;
    }
    
    return self;
}

-(void)dispose {
    [self checkTransportExists];
    
    [TransportWrapper nativeFreeTransport:self._nativeTransport];
}

-(Consumer *)consume:(Protocol<ConsumerListener> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters {
    return [self consume:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:nil];
}

-(Consumer *)consume:(Protocol<ConsumerListener> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    [self checkTransportExists];
    
    // TODO listener
    NSValue *consumerObject = [TransportWrapper nativeConsume:self._nativeTransport listener:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:appData];
    Consumer *consumer = [[Consumer alloc] initWithNativeConsumer:consumerObject];
    
    return consumer;
}

-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
