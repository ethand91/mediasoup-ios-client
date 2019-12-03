//
//  RecvTransportListenerImpl.h
//  mediasoup-client-iosTests
//
//  Created by Denvir Ethan on 2019/12/03.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef RecvTransportListenerImpl_h
#define RecvTransportListenerImpl_h
#import "RecvTransport.h"

@interface RecvTransportListenerImpl : NSObject<RecvTransportListener>
@property(nonatomic)id delegate;
@end

#endif /* RecvTransportListenerImpl_h */
