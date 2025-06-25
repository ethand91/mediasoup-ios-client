#import "DataProducerListenerImpl.h"

@interface DataProducerListenerImpl ()
@property (nonatomic, retain) id<DataProducerListener> delegateProperty;
@end

@implementation DataProducerListenerImpl

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegateProperty = self;
        _opened = NO;
        _closed = NO;
    }
    return self;
}

- (id<DataProducerListener>)delegate {
    return _delegateProperty;
}

- (void)onOpen:(DataProducer *)producer {
    self.opened = YES;
}

- (void)onClose:(DataProducer *)producer {
    self.closed = YES;
}

- (void)onBufferedAmountChange:(DataProducer *)producer sentDataSize:(uint64_t)sentDataSize {
    // no-op
}

- (void)onTransportClose:(DataProducer *)producer {
    self.closed = YES;
}

@end
