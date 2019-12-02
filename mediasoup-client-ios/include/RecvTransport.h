//
//  RecvTransport.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "WebRTC/RTCMediaStreamTrack.h"
#import "Transport.h"
#import "Consumer.h"

#ifndef RecvTransport_h
#define RecvTransport_h

@interface RecvTransport : Transport
@property(nonatomic) NSObject* _nativeTransport;

-(void)dispose;
-(Consumer *)consume:(Protocol<ConsumerListener> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters;
-(Consumer *)consume:(Protocol<ConsumerListener> *)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData;

@end


#endif /* RecvTransport_h */
