//
//  SendTransportListenerImpl.m
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendTransportListernerImpl.h"

@implementation SendTransportListenerImpl
-(id)init {
    self = [super init];
    
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

-(void)onConnect:(Transport *)transport dtlsParameters:(NSString *)dtlsParameters {
    NSLog(@"onConnect");
}

-(void)onConnectionStateChange:(Transport *)transport connectionState:(NSString *)connectionState {
    NSLog(@"onConnectionStateChange");
}

- (void)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData callback:(void (^)(NSString *))callback {
    NSLog(@"onProduce");
    
    callback(@"id");
}

@end
