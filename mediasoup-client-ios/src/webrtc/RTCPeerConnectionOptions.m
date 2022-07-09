//
//  RTCPeerConnectionOptions.m
//  mediasoup-client-ios
//
//  Created by Bojan Bozovic on 7/6/22.
//  Copyright © 2022 Denvir Ethan. All rights reserved.
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
