//
//  SendTransport.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <WebRTC/RTCMediaStreamTrack.h>
#import <WebRTC/RTCRtpEncodingParameters.h>

#import "Transport.h"
#import "Producer.h"

#ifndef SendTransport_h
#define SendTransport_h

@interface SendTransport : Transport
/*! @brief libmediasoupclient native send transport object */
@property(nonatomic, strong) NSValue* _nativeTransport;

/*! @brief Disposes of the send transport instance */
-(void)dispose;
/*!
    @brief Instructs the transport to send an audio or video track to the mediasoup router
    @param listener ProducerListener delegate
    @param track An audio or video track
    @param encodings Encoding settings
    @param codecOptions Per codec specific options
    @return Producer
 */
-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions;
/*!
   @brief Instructs the transport to send an audio or video track to the mediasoup router
   @param listener ProducerListener delegate
   @param track An audio or video track
   @param encodings Encoding settings
   @param codecOptions Per codec specific options
   @param appData Custom application data
   @return Producer
*/
-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData;

@end

@protocol SendTransportListener <TransportListener>
@required
/*!
    @brief Emitted when the transport needs to transmit information about a new producer to the associated server side transport.
    @discussion This even occurs <b>before</b> the produce() method completes
    @param transport SendTransport instance
    @param kind Producer's media kind (video or audio)
    @param rtpParameters Producer's RTP parameters
    @param appData Custom application data (given in the transport.producer() method)
    @param callback Callback that receives the id of the producer
 */
-(void)onProduce:(Transport *)transport kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData callback:(void(^)(NSString *))callback;
@end

#endif /* SendTransport_h */
