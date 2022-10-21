//
//  RecvTransport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

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

-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters {
    return [self consume:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:nil];
}

-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    [self checkTransportExists];
    
    @synchronized(self) {
        Consumer *consumer = [TransportWrapper nativeConsume:self._nativeTransport listener:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:appData];
        
        return consumer;
    }
}

-(DataConsumer *)consumeData:(id<DataConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId label:(NSString *)label protocol:(NSString *)protocol appData:(NSString *)appData {

    
    DataConsumer *consumer = [TransportWrapper nativeConsumeData:self._nativeTransport listener:listener id:id producerId:producerId label:label protocol:protocol appData:appData];
    
    return consumer;
}


-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
