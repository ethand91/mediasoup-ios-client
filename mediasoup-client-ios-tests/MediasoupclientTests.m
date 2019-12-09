//
//  MediasoupclientTests.m
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
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
