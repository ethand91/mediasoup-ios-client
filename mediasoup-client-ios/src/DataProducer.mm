//
//  DataProducer.mm
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProducer.h"
#import "DataProducerWrapper.h"

@implementation DataProducer : NSObject

-(instancetype)initWithNativeProducer:(NSValue *)nativeProducer {
    self = [super init];
    if (self) {
        self._nativeProducer = nativeProducer;
    }
    
    return self;
}

-(NSString *)getId {
    return [DataProducerWrapper getNativeId:self._nativeProducer];
}

-(NSString *)getSctpStreamParameters {
    return [DataProducerWrapper getNativeSctpStreamParameters:self._nativeProducer];
}

-(NSString *)getReadyState {
    return [DataProducerWrapper getNativeReadyState:self._nativeProducer];
}

-(NSString *)getLabel {
    return [DataProducerWrapper getNativeLabel:self._nativeProducer];
}

-(NSString *)getProtocol {
    return [DataProducerWrapper getNativeProtocol:self._nativeProducer];
}

-(uint64_t)getBufferedAmount {
    return [DataProducerWrapper getNativeBufferedAmount:self._nativeProducer];
}

-(NSString *)getAppData {
    return [DataProducerWrapper getNativeAppData:self._nativeProducer];
}

-(bool)isClosed {
    return [DataProducerWrapper isNativeClosed:self._nativeProducer];
}

-(void)close {
    [DataProducerWrapper nativeClose:self._nativeProducer];
    [self._nativeProducer release];
}

-(void)send:(NSData *)buffer {
    [DataProducerWrapper nativeSend:self._nativeProducer buffer:buffer];
}

@end
