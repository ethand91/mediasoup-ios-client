//
//  SendTransport.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//
#import "WebRTC/RTCMediaStreamTrack.h"
#import "WebRTC/RTCRtpEncodingParameters.h"
#import "Transport.h"
#import "Producer.h"

#ifndef SendTransport_h
#define SendTransport_h

@interface SendTransport : Transport
@property(nonatomic) NSObject* _nativeTransport;

-(void)dispose;
-(Producer *)produce:(Protocol<ProducerListener> *)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions;
-(Producer *)produce:(Protocol<ProducerListener> *)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData;

@end

#endif /* SendTransport_h */
