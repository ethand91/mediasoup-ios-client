//
//  RTCPeerConnectionOptions.h
//  mediasoup-client-ios
//
//  Created by Bojan Bozovic on 7/6/22.
//  Copyright © 2022 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCPeerConnectionOptions : NSObject
@property(nonatomic, strong) RTCConfiguration *config;
@end

NS_ASSUME_NONNULL_END
