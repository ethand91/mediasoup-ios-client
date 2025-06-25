#import "SendTransportListenerImpl.h"

@interface SendTransportListenerImpl ()
@property (nonatomic, retain) id<SendTransportListener> delegateProperty;
@end

@implementation SendTransportListenerImpl

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegateProperty = self;
        _produceId = @"PRODUCER_ID";
        _dataProduceId = @"DATA_PRODUCER_ID";
    }
    return self;
}

- (id<SendTransportListener>)delegate {
    return _delegateProperty;
}

- (void)onConnect:(Transport *)transport dtlsParameters:(NSString *)dtlsParameters {
    // no-op for tests
}

- (void)onConnectionStateChange:(Transport *)transport connectionState:(NSString *)connectionState {
    // no-op for tests
}

- (void)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData callback:(void (^)(NSString *))callback {
    callback(self.produceId);
}

- (void)onProduceData:(Transport *)transport sctpStreamParameters:(NSString *)sctpStreamParameters label:(NSString *)label protocol:(NSString *)protocol appData:(NSString *)appData callback:(void (^)(NSString *))callback {
    callback(self.dataProduceId);
}

@end
