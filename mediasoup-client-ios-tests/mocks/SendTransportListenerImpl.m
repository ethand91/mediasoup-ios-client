//
//  SendTransportListenerImpl.m
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/03.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
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

-(NSString *)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData {
    NSLog(@"onProduce");
    
    return @"id";
}

@end
