//
//  DataConsumer.cpp
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataConsumer.h"
#import "DataConsumerWrapper.h"

@implementation DataConsumer : NSObject

-(instancetype)initWithNativeConsumer:(NSValue *)nativeConsumer {
    self = [super init];
    if (self) {
        self._nativeConsumer = nativeConsumer;
    }
    
    return self;
}

-(NSString *)getId {
    return [DataConsumerWrapper getNativeId:self._nativeConsumer];
}

-(NSString *)getDataProducerId {
    return [DataConsumerWrapper getNativeDataProducerId:self._nativeConsumer];
}

-(NSString *)getSctpStreamParameters {
    return [DataConsumerWrapper getNativeSctpStreamParameters:self._nativeConsumer];
}

-(NSString *)getReadyState {
    return [DataConsumerWrapper getNativeReadyState:self._nativeConsumer];
}

-(NSString *)getLabel {
    return [DataConsumerWrapper getNativeLabel:self._nativeConsumer];
}

-(NSString *)getProtocol {
    return [DataConsumerWrapper getNativeProtocol:self._nativeConsumer];
}

-(NSString *)getAppData {
    return [DataConsumerWrapper getNativeAppData:self._nativeConsumer];
}

-(bool)isClosed {
    return [DataConsumerWrapper isNativeClosed:self._nativeConsumer];
}

-(void)close {
    [DataConsumerWrapper nativeClose:self._nativeConsumer];
    [self._nativeConsumer release];
}

@end
