//
//  ConsumerWrapper.cpp
//  Project
//
//  Created by Denvir Ethan on 2019/11/21.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#include "Include/ConsumerWrapper.hpp"
#include "Consumer.hpp"

const char * getNativeId(const void *object) {
    mediasoupclient::Consumer *consumer = (mediasoupclient::Consumer *)object;
    return consumer->GetId().c_str();
}

const char * getProducerId(const void *object) {
    mediasoupclient::Consumer *consumer = (mediasoupclient::Consumer *)object;
    return consumer->GetProducerId().c_str();
}

bool isClosed(const void *object) {
    mediasoupclient::Consumer *consumer = (mediasoupclient::Consumer *)object;
    return consumer->IsClosed();
}
