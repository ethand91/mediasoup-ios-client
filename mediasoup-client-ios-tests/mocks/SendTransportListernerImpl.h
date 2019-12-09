//
//  SendTransportListernerImpl.h
//  mediasoup-client-iosTests
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#ifndef SendTransportListernerImpl_h
#define SendTransportListernerImpl_h
#import "SendTransport.h"

@interface SendTransportListenerImpl : NSObject<SendTransportListener>
@property(nonatomic)id delegate;
@end


#endif /* SendTransportListernerImpl_h */
