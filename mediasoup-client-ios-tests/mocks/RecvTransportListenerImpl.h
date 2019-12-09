//
//  RecvTransportListenerImpl.h
//  mediasoup-client-iosTests
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#ifndef RecvTransportListenerImpl_h
#define RecvTransportListenerImpl_h
#import "RecvTransport.h"

@interface RecvTransportListenerImpl : NSObject<RecvTransportListener>
@property(nonatomic)id delegate;
@end

#endif /* RecvTransportListenerImpl_h */
