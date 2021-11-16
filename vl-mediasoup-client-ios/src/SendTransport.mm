//
//  SendTransport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCMediaStreamTrack.h>
#import "SendTransport.h"
#import "TransportWrapper.h"
#import "Producer.h"

@implementation SendTransport : Transport

-(void)dealloc {
    [TransportWrapper nativeFreeSendTransport:self._nativeTransport];
    self._nativeTransport = nil;
}

-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions {
    return [self produce:listener track:track encodings:encodings codecOptions:codecOptions appData:nil];
}

-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData {
    NSUInteger nativeTrack = track.hash;

    @try {
        Producer *producer = [TransportWrapper nativeProduce:self._nativeTransport listener:listener track:nativeTrack encodings:encodings codecOptions:codecOptions appData:appData];
        return producer;
    } @catch (...) {
        return nil;
    }
}

-(void)checkTransportExists {
    if (self._nativeTransport == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"RecvTransport has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
