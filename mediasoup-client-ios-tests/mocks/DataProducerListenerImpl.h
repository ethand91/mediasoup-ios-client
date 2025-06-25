#import <Foundation/Foundation.h>
#import "DataProducer.h"

@interface DataProducerListenerImpl : NSObject<DataProducerListener>
@property (nonatomic, readonly) id<DataProducerListener> delegate;
@property (nonatomic, assign) BOOL opened;
@property (nonatomic, assign) BOOL closed;
@end
