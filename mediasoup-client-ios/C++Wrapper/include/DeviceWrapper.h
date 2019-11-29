//
//  DeviceWrapper.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Device.hpp"

#ifndef DeviceWrapper_h
#define DeviceWrapper_h

@interface DeviceWrapper : NSObject {}
+(NSObject *)nativeNewDevice;
+(void)nativeFreeDevice:(NSObject *)nativeDevice;
+(void)nativeLoad:(NSObject *)nativeDevice routerRtpCapabilities:(NSString *)routerRtpCapabilities;
+(bool)nativeIsLoaded:(NSObject *)nativeDevice;
+(NSString *)nativeGetRtpCapabilities:(NSObject *)nativeDevice;
+(bool)nativeCanProduce:(NSObject *)nativeDevice kind:(NSString *)kind;
@end

#endif /* DeviceWrapper_h */
