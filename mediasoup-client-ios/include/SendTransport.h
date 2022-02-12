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
#import "DataProducer.h"

#ifndef SendTransport_h
#define SendTransport_h

@interface SendTransport : Transport
/*! @brief libmediasoupclient native send transport object */
@property(nonatomic, strong) NSValue* _nativeTransport;

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
/*!
   @brief Instructs the transport to send data via DataChannel to the mediasoup router
   @param listener DataProducerListener delegate
   @param label A label which can be used to distinguish this DataChannel from others
   @param protocol Name of the sub-protocol used by this DataChannel
   @param ordered Whether data messages must be received in order. if true the messages will be sent reliably
   @param maxPacketLifeTime When ordered is false indicates the time (in milliseconds) after which a SCTP packet will stop being retransmitted
   @param maxRetransmits When ordered is false indicates the maximum number of times a packet will be retransmitted
   @param appData Custom application data
   @return DataProducer
*/
-(DataProducer *)produceData:(id<DataProducerListener>)listener label:(NSString *)label protocol:(NSString *)protocol ordered:(bool)ordered maxPacketLifeTime:(int)maxPacketLifeTime maxRetransmits:(int)maxRetransmits appData:(NSString *)appData;

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

/*!
    @brief Emitted when the transport needs to transmit information about a new data producer to the associated server side transport
    @discussion This even occurs <b>before</b> the produceData() method completes
    @param transport SendTransport instance
    @param sctpStreamParameters Producer's SCTP parameters
    @param label A label which can be used to distinguish this DataChannel from others
    @param protocol Name of the sub-protocol used by this DataChannel
    @param appData Custom application data (given in the transport.producer() method)
    @param callback Callback that receives the id of the producer
 */
-(void)onProduceData:(Transport *)transport sctpStreamParameters:(NSString *)sctpStreamParameters label:(NSString *)label protocol:(NSString *)protocol appData:(NSString *)appData callback:(void(^)(NSString *))callback;
@end

#endif /* SendTransport_h */
