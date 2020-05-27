//
//  TransportTests.m
//  mediasoup-client-iosTests
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Device.h"
#import "SendTransport.h"
#import "RTCUtils.h"

#import "data/Parameters.h"
#import "mocks/SendTransportListernerImpl.h"
#import "mocks/RecvTransportListenerImpl.h"
#import "utils/util.h"

@interface TransportTests : XCTestCase<SendTransportListener, RecvTransportListener, ProducerListener>
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) SendTransport *sendTransport;
@property (nonatomic, strong) RecvTransport *recvTransport;
@property (nonatomic, strong) NSString *connectionState;
@property (nonatomic, strong) RTCAudioTrack *track;
@property (nonatomic, strong) NSArray *encodings;
@property (nonatomic) id delegate;
@property (nonatomic) id producerDelegate;
@end

@implementation TransportTests

- (void)setUp {
    [super setUp];
    self.device = [[Device alloc] init];
    [self.device load:[Parameters generateRouterRtpCapabilities]];

    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    self.delegate = self;
    
    self.recvTransport = [self.device createRecvTransport:self.delegate
                                                             id:id
                                                             iceParameters:[Util dictionaryToJson:iceParameters]
                                                             iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                             dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
     
    self.sendTransport = [self.device createSendTransport:self.delegate
                                                       id:id
                                                       iceParameters:[Util dictionaryToJson:iceParameters]
                                                       iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                       dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
}

- (void)tearDown {
}

-(void)testGetId {
    XCTAssertNotNil([self.sendTransport getId]);
    XCTAssertNotNil([self.recvTransport getId]);
}

-(void)testGetConnectionState {
    XCTAssertNotNil([self.sendTransport getConnectionState]);
    XCTAssertNotNil([self.recvTransport getConnectionState]);
}

-(void)testGetAppData {
    XCTAssertNotNil([self.sendTransport getAppData]);
    XCTAssertNotNil([self.recvTransport getAppData]);
}

-(void)testGetStats {
    XCTAssertNotNil([self.sendTransport getStats]);
    XCTAssertNotNil([self.recvTransport getStats]);
}

-(void)testClosed {
    XCTAssertFalse([self.sendTransport isClosed]);
    XCTAssertFalse([self.recvTransport isClosed]);
}

-(void)testClose {
    [self.sendTransport close];
    [self.recvTransport close];
    
    XCTAssertTrue([self.sendTransport isClosed]);
    XCTAssertTrue([self.recvTransport isClosed]);
}

-(void)testRestartIce {
    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    XCTAssertNoThrow([self.sendTransport restartIce:[Util dictionaryToJson:iceParameters]]);
    XCTAssertNoThrow([self.recvTransport restartIce:[Util dictionaryToJson:iceParameters]]);
}

-(void)testProduce {
    RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
    self.track = [factory audioTrackWithTrackId:@"dsdasdsa"];
    self.producerDelegate = self;
    
    // TODO
    RTCRtpEncodingParameters *encoding1 = [RTCUtils genRtpEncodingParameters:true maxBitrateBps:500000 minBitrateBps:0 maxFramerate:60 numTemporalLayers:0 scaleResolutionDownBy:0.0];
    
    self.encodings = @[encoding1];
    
    Producer *producer = [self.sendTransport produce:self.delegate track:self.track encodings:nil codecOptions:nil];
    XCTAssertNotNil(producer);
}

/* TODO
-(void)testUpdateIceServers {
    NSString *iceServers = [Parameters generateIceServers];
    
    XCTAssertNoThrow([self.sendTransport updateIceServers:iceServers]);
    XCTAssertNoThrow([self.recvTransport updateIceServers:iceServers]);
}
*/

-(void)onConnect:(Transport *)transport dtlsParameters:(NSString *)dtlsParameters {
    
}

-(void)onConnectionStateChange:(Transport *)transport connectionState:(NSString *)connectionState {
    self.connectionState = connectionState;
}

- (void)onTransportClose:(Producer *)producer {
    
}

- (void)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData callback:(void (^)(NSString *))callback {
    NSLog(@"Test %@", callback);
    
    callback(@"id");
}

@end
