//
//  SendTransport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendTransport.h"
#import "TransportWrapper.h"
#import "Producer.h"

@implementation SendTransport : Transport

-(instancetype)initWithNativeTransport:(NSValue *)nativeTransport {
    self = [super initWithNativeTransport:nativeTransport];
    if (self) {
        self._nativeTransport = nativeTransport;
    }
    
    return self;
}

-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions {
    return [self produce:listener track:track encodings:encodings codecOptions:codecOptions appData:nil];
}

-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    NSUInteger nativeTrack = track.hash;
    
    Producer *producer = [TransportWrapper nativeProduce:self._nativeTransport listener:listener track:nativeTrack encodings:encodings codecOptions:codecOptions appData:appData];
    
    return producer;
}

-(DataProducer *)produceData:(id<DataProducerListener>)listener label:(NSString *)label protocol:(NSString *)protocol ordered:(bool)ordered maxPacketLifeTime:(int)maxPacketLifeTime maxRetransmits:(int)maxRetransmits appData:(NSString *)appData {
    
    DataProducer *producer = [TransportWrapper nativeProduceData:self._nativeTransport listener:listener label:label protocol:protocol ordered:ordered maxPacketLifeTime:maxPacketLifeTime maxRetransmits:maxRetransmits appData:appData];
    
    return producer;
}

-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
