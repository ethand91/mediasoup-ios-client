//
//  Util.m
//  mediasoup-client-iosTests
//
//  Created by Denvir Ethan on 2019/12/03.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h"

@implementation Util

+(NSString *)dictionaryToJson:(NSDictionary *)dictionary {
    NSData *valueJson = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:valueJson encoding:NSUTF8StringEncoding];
}

@end
