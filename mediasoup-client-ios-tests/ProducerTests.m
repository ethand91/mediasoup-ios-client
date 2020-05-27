//
//  ProducerTests.m
//  mediasoup-client-iosTests
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebRTC/RTCPeerConnectionFactory.h"
#import "WebRTC/RTCAudioTrack.h"

#import "Device.h"
#import "SendTransport.h"
#import "Mediasoupclient.h"
#import "Logger.h"
#import "data/Parameters.h"
#import "mocks/SendTransportListernerImpl.h"
#import "mocks/RecvTransportListenerImpl.h"
#import "utils/util.h"

@interface ProducerTests : XCTestCase<ProducerListener>
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) SendTransport *sendTransport;
@property (nonatomic, strong) Producer *producer;
@property (nonatomic, strong) RTCAudioTrack *track;
@property (nonatomic, assign) id delegate;
@end

@implementation ProducerTests

- (void)setUp {
    [super setUp];
    
    [Mediasoupclient initializePC];
    
    self.device = [[Device alloc] init];
    [self.device load:[Parameters generateRouterRtpCapabilities]];

    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    SendTransportListenerImpl *listener = [[SendTransportListenerImpl alloc] init];
    
    self.sendTransport = [self.device createSendTransport:listener.delegate
                                                       id:id
                                                       iceParameters:[Util dictionaryToJson:iceParameters]
                                                       iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                       dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
    
    
    RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
    self.track = [factory audioTrackWithTrackId:@"dsdasdsa"];
    self.delegate = self;
    
    self.producer = [self.sendTransport produce:self.delegate track:self.track encodings:@[] codecOptions:nil];
}

- (void)tearDown {
}

-(void)testGetId {
    XCTAssertNotNil([self.producer getId]);
}

-(void)testIsNotClosed {
    XCTAssertFalse([self.producer isClosed]);
}

-(void)testGetKind {
    XCTAssertTrue([self.producer.getKind isEqualToString:@"audio"]);
}

-(void)testGetRtpParameters {
    XCTAssertNotNil([self.producer getRtpParameters]);
}

-(void)testGetAppData {
    XCTAssertNotNil([self.producer getAppData]);
}

-(void)testGetTrack {
    RTCMediaStreamTrack *track = [self.producer getTrack];
    XCTAssertNotNil(track);
    XCTAssertTrue([[track kind] isEqualToString:@"audio"]);
}

-(void)testTransportClose {
    [self.sendTransport close];
    XCTAssertTrue([self.producer isClosed]);
}

-(void)testNotPaused {
    XCTAssertFalse([self.producer isPaused]);
}

-(void)testGetMaxSpatialLayer {
    XCTAssertEqual([self.producer getMaxSpatialLayer], 0);
}

-(void)testPause {
    [self.producer pause];
    XCTAssertTrue([self.producer isPaused]);
}

-(void)testResume {
    [self.producer pause];
    XCTAssertTrue([self.producer isPaused]);
    
    [self.producer resume];
    XCTAssertFalse([self.producer isPaused]);
}

-(void)testReplaceTrack {
    RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
    RTCAudioTrack *newTrack = [factory audioTrackWithTrackId:@"new"];
    
    [self.producer replaceTrack:newTrack];
    XCTAssertTrue([[self.producer getTrack].trackId isEqualToString:@"new"]);
}

-(void)testGetStats {
    XCTAssertNotNil([self.producer getStats]);
}

-(void)testClose {
    [self.producer close];
    XCTAssertTrue([self.producer isClosed]);
}

-(void)onTransportClose:(Producer *)producer {
    NSLog(@"onTransportClose");
}

@end
