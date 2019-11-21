//
//  ConsumerWrapper.hpp
//  Project
//
//  Created by Denvir Ethan on 2019/11/21.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef ConsumerWrapper_hpp
#define ConsumerWrapper_hpp
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

const char * getNativeId(const void *object);
const char * getProducerId(const void *object);
bool isClosed(const void *object);

#ifdef __cplusplus
}
#endif


#endif /* ConsumerWrapper_hpp */
