//
//  DeviceWrapperTests.m
//  ProjectTests
//
//  Created by Denvir Ethan on 2019/11/26.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Device.h"
#import "SendTransport.h"

#import "data/Parameters.h"
#import "mocks/SendTransportListernerImpl.h"
#import "mocks/RecvTransportListenerImpl.h"
#import "utils/util.h"

@interface DeviceTests : XCTestCase
@property (nonatomic) Device *device;
@end

@implementation DeviceTests

- (void)setUp {
    [super setUp];
    self.device = [[Device alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

-(void)testDeviceLoadFailed {
    XCTAssertThrowsSpecific([self.device load:@""], NSException, @"Failed to load mediasoup device");
}

-(void)testDeviceLoadedFalse {
    XCTAssertFalse([self.device isLoaded]);
}

-(void)testDeviceLoadSuccess {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    XCTAssertTrue([self.device isLoaded]);
}

-(void)testGetRtpCapabilitiesSuccess {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    XCTAssertNotNil([self.device getRtpCapabilities]);
}

-(void)testGetRtpCapabilitiesFail {
    XCTAssertThrowsSpecific([self.device getRtpCapabilities], NSException, @"Not loaded");
}

-(void)testCanProduceVideoSuccess {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    
    XCTAssertTrue([self.device canProduce:@"video"]);
}

-(void)testCanProduceAudioSuccess {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    
    XCTAssertTrue([self.device canProduce:@"audio"]);
}

-(void)testCanProduceVideoFailure {
    [self.device load:[Parameters generateRouterRtpCapabilities:false includeAudio:true]];
    
    XCTAssertFalse([self.device canProduce:@"video"]);
}

-(void)testCanProduceAudioFailure {
    [self.device load:[Parameters generateRouterRtpCapabilities:true includeAudio:false]];
    
    XCTAssertFalse([self.device canProduce:@"audio"]);
}

-(void)testCanProduceVideoNotLoaded {
    XCTAssertThrowsSpecific([self.device canProduce:@"video"], NSException, @"Not loaded");
}

-(void)testCanProduceAudioNotLoaded {
    XCTAssertThrowsSpecific([self.device canProduce:@"audio"], NSException, @"Not loaded");
}

-(void)testInvalidCanProduceArgument {
    XCTAssertThrowsSpecific([self.device canProduce:@"bacon"], NSException, @"invalid kind");
}

-(void)testCreateSendTransportSuccess {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    
    SendTransportListenerImpl *listener = [[SendTransportListenerImpl alloc] init];
    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    SendTransport *transport = [self.device createSendTransport:listener.delegate
                                                            id:id
                                                            iceParameters:[Util dictionaryToJson:iceParameters]
                                                            iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                            dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
    
    XCTAssertTrue([[transport getId] isEqualToString:id]);
}

-(void)testCreateSendTransportFailure {
    SendTransportListenerImpl *listener = [[SendTransportListenerImpl alloc] init];
    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    XCTAssertThrowsSpecific([self.device createSendTransport:listener.delegate
                                                          id:id
                                                          iceParameters:[Util dictionaryToJson:iceParameters]
                                                          iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                          dtlsParameters:[Util dictionaryToJson:dtlsParameters]],
                                                          NSException, @"Not loaded");
}

-(void)testCreateRecvTransportSuccess {
    [self.device load:[Parameters generateRouterRtpCapabilities]];
    
    RecvTransportListenerImpl *listener = [[RecvTransportListenerImpl alloc] init];
    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    RecvTransport *transport = [self.device createRecvTransport:listener.delegate
                                                             id:id
                                                             iceParameters:[Util dictionaryToJson:iceParameters]
                                                             iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                             dtlsParameters:[Util dictionaryToJson:dtlsParameters]];
    
    XCTAssertTrue([[transport getId] isEqualToString:id]);
}

-(void)testCreateRecvTransportFailure {
    RecvTransportListenerImpl *listener = [[RecvTransportListenerImpl alloc] init];
    NSDictionary *remoteTransportParameters = [Parameters generateTransportRemoteParameters];
    
    NSString *id = [remoteTransportParameters valueForKeyPath:@"id"];
    NSDictionary *dtlsParameters = [remoteTransportParameters valueForKeyPath:@"dtlsParameters"];
    NSDictionary *iceCandidates = [remoteTransportParameters valueForKeyPath:@"iceCandidates"];
    NSDictionary *iceParameters = [remoteTransportParameters valueForKeyPath:@"iceParameters"];
    
    XCTAssertThrowsSpecific([self.device createRecvTransport:listener.delegate
                                                          id:id
                                                          iceParameters:[Util dictionaryToJson:iceParameters]
                                                          iceCandidates:[Util dictionaryToJson:iceCandidates]
                                                          dtlsParameters:[Util dictionaryToJson:dtlsParameters]],
                                                          NSException, @"Not loaded");
}

@end
