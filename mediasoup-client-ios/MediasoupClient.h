//
//  MediasoupClient.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/11/28.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef MediasoupClient_h
#define MediasoupClient_h
#include "DeviceWrapper.h"

#ifdef __cplusplus
extern "C" {
#endif
const char *initialize();
const DeviceWrapper * createDevice();
#ifdef __cplusplus
}
#endif

#endif /* MediasoupClient_h */
