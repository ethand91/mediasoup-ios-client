//
//  RTCPeerConnectionOptions.m
//  mediasoup-client-ios
//
//  Created by Muhammad on 02/01/2025.
//  Copyright © 2025 Denvir Ethan. All rights reserved.
//

#import "RTCPeerConnectionOptions.h"

@implementation RTCPeerConnectionOptions

-(instancetype)initWith:(RTConfiguration *)config {
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

@end
