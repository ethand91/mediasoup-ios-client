//
//  ProducerTests.m
//  mediasoup-client-iosTests
//
//  Created by Denvir Ethan on 2019/12/03.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
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
@property (nonatomic) Device *device;
@property (nonatomic) SendTransport *sendTransport;
@property (nonatomic) Producer *producer;
@property (nonatomic) id delegate;
@end

@implementation ProducerTests

- (void)setUp {
    [super setUp];
    
    [Logger setDefaultHandler];
    [Logger setLogLevel:4];
    
    self.device = [[Device alloc] init];
    [self.device load:[Parameters generateRouterRtpCapabilities]];

    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    SendTransportListenerImpl *listener = [[SendTransportListenerImpl alloc] init];
    
    NSLog(@"Test 1 %@", listener);
    self.sendTransport = [self.device createSendTransport:listener.delegate
                                                       id:id
                                                       iceParameters:[Util dictionaryToJson:iceParameters]
                                                       iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                       dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
    
    NSLog(@"Test 2");
    
    RTCPeerConnectionFactory *factory = [[RTCPeerConnectionFactory alloc] init];
    NSLog(@"Factory %@", factory);
    RTCAudioTrack *audioTrack = [factory audioTrackWithTrackId:@"dsdasdsa"];
    self.delegate = self;
    
    NSLog(@"Test 3 %@", audioTrack);
    self.producer = [self.sendTransport produce:self.delegate track:audioTrack encodings:@[] codecOptions:nil];
    NSLog(@"Test 4");
}

- (void)tearDown {
}

-(void)testGetId {
    XCTAssertNotNil([self.producer getId]);
}

-(void)onTransportClose:(Producer *)producer {
    
}

@end
