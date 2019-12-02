//
//  MediasoupclientTests.m
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Mediasoupclient.h"

@interface MediasoupclientTests : XCTestCase

@end

@implementation MediasoupclientTests

-(void)testMediasoupclientVersion {
    NSString *version = [Mediasoupclient version];
    XCTAssertNotNil(version);
}

@end
