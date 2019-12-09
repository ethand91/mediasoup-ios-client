//
//  Transport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transport.h"
#import "TransportWrapper.h"

@implementation Transport : NSObject

-(instancetype)initWithNativeTransport:(NSValue *)nativeTransport {
    self = [super init];
    if (self) {
        self._nativeTransport = nativeTransport;
    }
    
    return self;
}

-(NSString *)getId {
    return [TransportWrapper getNativeId:self._nativeTransport];
}

-(NSString *)getConnectionState {
    return [TransportWrapper getNativeConnectionState:self._nativeTransport];
}

-(NSString *)getAppData {
    return [TransportWrapper getNativeAppData:self._nativeTransport];
}

-(NSString *)getStats {
    return [TransportWrapper getNativeStats:self._nativeTransport];
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
    [TransportWrapper nativeClose:self._nativeTransport];
}

@end
