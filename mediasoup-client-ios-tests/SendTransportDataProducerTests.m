#import <XCTest/XCTest.h>
#import "Device.h"
#import "SendTransport.h"
#import "DataProducer.h"

#import "data/Parameters.h"
#import "mocks/SendTransportListenerImpl.h"
#import "mocks/DataProducerListenerImpl.h"
#import "utils/util.h"

@interface SendTransportDataProducerTests : XCTestCase
@property (nonatomic) Device *device;
@end

@implementation SendTransportDataProducerTests

- (void)setUp {
    [super setUp];
    self.device = [[MediasoupDevice alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (SendTransport *)createTransportWithListener:(SendTransportListenerImpl **)listenerOut {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    SendTransportListenerImpl *listener = [[SendTransportListenerImpl alloc] init];
    NSDictionary *params = [Parameters generateTransportRemoteParameters];
    NSString *tid = params[@"id"];
    NSString *dtls = params[@"dtlsParameters"];
    NSString *iceCandidates = params[@"iceCandidates"];
    NSString *iceParams = params[@"iceParameters"];
    SendTransport *transport = [self.device createSendTransport:listener.delegate
                                                             id:tid
                                                     iceParameters:[Util dictionaryToJson:iceParams]
                                                     iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                     dtlsParameters:[Util dictionaryToJson:dtls]];
    if (listenerOut) *listenerOut = listener;
    return transport;
}

- (void)testProduceDataReturnsId {
    SendTransportListenerImpl *listener;
    SendTransport *transport = [self createTransportWithListener:&listener];
    DataProducerListenerImpl *dpListener = [[DataProducerListenerImpl alloc] init];
    DataProducer *producer = [transport produceData:dpListener.delegate
                                              label:@""
                                            protocol:@""
                                            ordered:NO
                                   maxPacketLifeTime:0
                                    maxRetransmits:0
                                             appData:nil];
    XCTAssertEqualObjects([producer getId], listener.dataProduceId);
}

- (void)testDataProducerCloseMarksClosed {
    SendTransportListenerImpl *listener;
    SendTransport *transport = [self createTransportWithListener:&listener];
    DataProducerListenerImpl *dpListener = [[DataProducerListenerImpl alloc] init];
    DataProducer *producer = [transport produceData:dpListener.delegate
                                              label:@"test"
                                            protocol:@""
                                            ordered:YES
                                   maxPacketLifeTime:0
                                    maxRetransmits:0
                                             appData:nil];
    XCTAssertFalse([producer isClosed]);
    [producer close];
    XCTAssertTrue([producer isClosed]);
}

- (void)testSendTransportCloseMarksClosed {
    SendTransportListenerImpl *listener;
    SendTransport *transport = [self createTransportWithListener:&listener];
    XCTAssertFalse([transport isClosed]);
    [transport close];
    XCTAssertTrue([transport isClosed]);
}

@end
