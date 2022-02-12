//
//  RecvTransport.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <WebRTC/RTCMediaStreamTrack.h>

#import "Transport.h"
#import "Consumer.h"
#import "DataConsumer.h"

#ifndef RecvTransport_h
#define RecvTransport_h

@interface RecvTransport : Transport
/*! @brief libmediasoupclient native recv transport object */
@property(nonatomic, strong) NSValue* _nativeTransport;

/*!
    @brief Instructs the transport to receive an audio or video track to the mediasoup router
    @param listener ConsumerListener delegate
    @param id The identifier of the server side consumer
    @param producerId The identifier of the server side producer being consumed
    @param kind Media kind (video or audio)
    @param rtpParameters Receive RTP parameters
    @return Consumer
 */
-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters;
/*!
   @brief Instructs the transport to receive an audio or video track to the mediasoup router
   @param listener ConsumerListener delegate
   @param id The identifier of the server side consumer
   @param producerId The identifier of the server side producer being consumed
   @param kind Media kind (video or audio)
   @param rtpParameters Receive RTP parameters
   @param appData Custom application data
   @return Consumer
*/
-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData;
/*!
   @brief Instructs the transport to receive data via DataChannel from the mediasoup router
   @param listener DataConsumerListener delegate
   @param id The identifier of the server side consumer
   @param producerId The identifier of the server side producer being consumed
   @param label A label which can be used to distinguish this DataChannel from others
   @param protocol Name of the sub-protocol used by this DataChannel
   @param appData Custom application data
   @return DataConsumer
*/
-(DataConsumer *)consumeData:(id<DataConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId label:(NSString *)label protocol:(NSString *)protocol appData:(NSString *)appData;

@end

@protocol RecvTransportListener <TransportListener>

@end


#endif /* RecvTransport_h */
