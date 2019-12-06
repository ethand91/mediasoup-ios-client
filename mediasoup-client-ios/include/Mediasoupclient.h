//
//  Mediasoupclient.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/11/29.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Mediasoupclient_h
#define Mediasoupclient_h

@interface Mediasoupclient : NSObject {}
+(NSString *)version;
+(void)initializePC;
+(void)cleanup;
@end

#endif /* Mediasoupclient_h */
