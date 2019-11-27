//
//  Device.h
//  Project
//
//  Created by Denvir Ethan on 2019/11/25.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#include "Device.hpp"

#ifndef Device_h
#define Device_h

@interface DeviceWrapper : NSObject
@end

@interface DeviceWrapper ()
@property(atomic, readonly, assign) mediasoupclient::Device *device;
@end

#endif /* Device_h */
