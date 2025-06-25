#import <Foundation/Foundation.h>
#import "SendTransport.h"

@interface SendTransportListenerImpl : NSObject<SendTransportListener>
@property (nonatomic, readonly) id<SendTransportListener> delegate;
@property (nonatomic, readonly) NSString *produceId;
@property (nonatomic, readonly) NSString *dataProduceId;
@end
