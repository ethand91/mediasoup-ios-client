//
//  SendTransportListernerImpl.h
//  mediasoup-client-iosTests
//
//  Created by Denvir Ethan on 2019/12/03.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef SendTransportListernerImpl_h
#define SendTransportListernerImpl_h
#import "SendTransport.h"

@interface SendTransportListenerImpl : NSObject<SendTransportListener>
@property(nonatomic)id delegate;
@end


#endif /* SendTransportListernerImpl_h */
