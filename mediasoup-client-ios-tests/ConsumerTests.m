//
//  ConsumerTests.m
//  mediasoup-client-iosTests
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebRTC/RTCAudioSession.h"
#import "WebRTC/RTCAudioSessionConfiguration.h"
#import "Consumer.h"
#import "Device.h"
#import "RecvTransport.h"
#import "Parameters.h"
#import "RecvTransportListenerImpl.h"
#import "Mediasoupclient.h"
#import "util.h"
#import "Logger.h"

@interface ConsumerTests : XCTestCase<ConsumerListener>
@property(nonatomic, strong) Device *device;
@property(nonatomic, strong) RecvTransport *recvTransport;
@property(nonatomic, strong) Consumer *consumer;
@property(nonatomic, assign) id delegate;
@end

@implementation ConsumerTests

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
    
    RecvTransportListenerImpl *listener = [[RecvTransportListenerImpl alloc] init];
    
    self.recvTransport = [self.device createRecvTransport:listener.delegate
                                                       id:id
                                                       iceParameters:[Util dictionaryToJson:iceParameters]
                                                       iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                       dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
    
    NSLog(@"Transport created");
    
    NSDictionary *remoteConsumerParameters = [Parameters generateConsumerRemoteParameters];
    NSString *consumerId = [remoteConsumerParameters valueForKey:@"id"];
    NSString *kind = [remoteConsumerParameters valueForKey:@"kind"];
    NSString *producerId = [remoteConsumerParameters valueForKey:@"producerId"];
    NSDictionary *rtpParameters = [remoteConsumerParameters valueForKey:@"rtpParameters"];
    
    NSLog(@"To infinity and beyond! %@", consumerId);

    if (![[RTCAudioSession sharedInstance] respondsToSelector:@selector(setConfiguration:active:error:)]) {
        NSLog(@"Der be no selector boy");
    } else {
        NSLog(@"We Gots a selector!");
    }

    self.delegate = self;
    self.consumer = [self.recvTransport consume:self.delegate id:consumerId producerId:producerId kind:kind rtpParameters:[Util dictionaryToJson:rtpParameters]];
    NSLog(@"Setup done");
}

- (void)tearDown {
}

-(void)testGetId {
    XCTAssertNotNil([self.consumer getId]);
    XCTAssertTrue([[self.consumer getId] isEqualToString:@"consumer"]);
}

-(void)testGetProducerId {
    XCTAssertNotNil([self.consumer getProducerId]);
    XCTAssertTrue([[self.consumer getProducerId] isEqualToString:@"producer"]);
}

-(void)testIsNotClosed {
    XCTAssertFalse([self.consumer isClosed]);
}

-(void)testNotPaused {
    XCTAssertFalse([self.consumer isPaused]);
}

-(void)testGetKind {
    XCTAssertTrue([[self.consumer getKind] isEqualToString:@"audio"]);
}

-(void)testGetTrack {
    XCTAssertNotNil([self.consumer getTrack]);
    XCTAssertTrue([[[self.consumer getTrack] kind] isEqualToString:@"audio"]);
}

-(void)testGetRtpParameters {
    XCTAssertNotNil([self.consumer getRtpParameters]);
}

-(void)testGetAppData {
    XCTAssertNotNil([self.consumer getAppData]);
}

-(void)testGetStats {
    XCTAssertNotNil([self.consumer getStats]);
}

-(void)testPause {
    [self.consumer pause];
    XCTAssertTrue([self.consumer isPaused]);
}

-(void)testResume {
    [self.consumer pause];
    XCTAssertTrue([self.consumer isPaused]);
    
    [self.consumer resume];
    XCTAssertFalse([self.consumer isPaused]);
}

-(void)testClose {
    [self.consumer close];
    XCTAssertTrue([self.consumer isClosed]);
}

-(void)onTransportClose:(Consumer *)consumer {
    NSLog(@"onTransportClose");
}

@end
