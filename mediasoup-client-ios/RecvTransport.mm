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

-(void)dispose {
    [self checkTransportExists];
    
    [TransportWrapper nativeFreeTransport:self._nativeTransport];
}

-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters {
    return [self consume:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:nil];
}

-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    [self checkTransportExists];
    
    __block Consumer *consumer;
    // The below MUST run on the same thread, otherwise it leads to a race problem
    // when called at the same time on a different thread (sdp answer is produced with both video and audio being mid:0)
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_block_t block = ^{
        NSValue *nativeConsumer = [TransportWrapper nativeConsume:self._nativeTransport listener:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:appData];
        
        consumer = [[Consumer alloc] initWithNativeConsumer:nativeConsumer];
    };
    
    // Prevent deadlock if already on the main thread
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(main, block);
    }
    
    return consumer;
}

-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
