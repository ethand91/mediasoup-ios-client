//
//  Transport.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Transport_h
#define Transport_h

@interface Transport : NSObject
@property(nonatomic) NSValue* _nativeTransport;

-(NSString *)getId;
-(NSString *)getConnectionState;
-(NSString *)getAppData;
-(NSString *)getStats;
-(bool)isClosed;
-(void)restartIce:(NSString *)iceParameters;
-(void)updateIceServers:(NSString *)iceServers;
-(void)close;

@end

@protocol TransportListener <NSObject>

@required
-(void)onConnect:(Transport *)transport dtlsParameters:(NSString *)dtlsParameters;
-(void)onConnectionStateChange:(Transport *)transport connectionState:(NSString *)connectionState;

@end

#endif /* Transport_h */
