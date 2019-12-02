//
//  DeviceWrapperTests.m
//  ProjectTests
//
//  Created by Denvir Ethan on 2019/11/26.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Device.h"

#import "data/Parameters.h"

@interface DeviceTests : XCTestCase
@property (nonatomic) Device *device;
@end

@implementation DeviceTests

- (void)setUp {
    [super setUp];
    self.device = [[Device alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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

@end
