//
//  RTCPeerConnectionOptions.h
//  mediasoup-client-ios
//
//  Created by Muhammad on 02/01/2025.
//  Copyright © 2025 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCPeerConnectionOptions : NSObject
@property(nonatomic, strong) RTCConfiguration *config;
@end

NS_ASSUME_NONNULL_END
