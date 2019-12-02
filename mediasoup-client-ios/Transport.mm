//
//  Transport.m
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transport.h"
#import "TransportWrapper.h"

@implementation Transport : NSObject

-(id)initWithNativeTransport:(NSObject *)nativeTransport {
    self = [super init];
    if (self) {
        self._nativeTransport = nativeTransport;
    }
    
    return self;
}

-(NSString *)getId {
    return [TransportWrapper nativeGetId:self._nativeTransport];
}

-(NSString *)getConnectionState {
    return [TransportWrapper nativeGetConnectionState:self._nativeTransport];
}

-(NSString *)getAppData {
    return [TransportWrapper nativeGetData:self._nativeTransport];
}

-(NSString *)getStats {
    return [TransportWrapper nativeGetStats:self._nativeTransport];
}

-(bool)isClosed {
    return [TransportWrapper isNativeClosed:self._nativeTransport];
}

-(void)restartIce:(NSString *)iceParameters {
    [TransportWrapper nativeRestartIce:self._nativeTransport iceParameters:iceParameters];
}

-(void)updateIceServers:(NSString *)iceServers {
    [TransportWrapper nativeUpdateIceServers:self._nativeTransport iceServers:iceServers];
}

-(void)close {
    [TransportWrapper close:self._nativeTransport];
}

@end
