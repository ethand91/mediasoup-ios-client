//
//  DataConsumer.h
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#ifndef DataConsumer_h
#define DataConsumer_h

@interface DataConsumer : NSObject
/*! @brief libmediasoupclient native data consumer object */
@property(nonatomic, strong) NSValue* _nativeConsumer;

/*! @return Consumer identifier */
-(NSString *)getId;
/*! @return The associated data producer identifier */
-(NSString *)getDataProducerId;
/*! @return The SCTP stream parameters */
-(NSString *)getSctpStreamParameters;
/*! @return The DataChannel ready state */
-(NSString *)getReadyState;
/*! @return The DataChannel label */
-(NSString *)getLabel;
/*! @return The DataChannel sub-protocol */
-(NSString *)getProtocol;
/*! @return Custom data Object provided by the application in the data consumer factory method. The app can modify its content at any time */
-(NSString *)getAppData;
/*! @return Whether the consumer is closed */
-(bool)isClosed;
/*!
    @brief Closes the data consumer.
 */
-(void)close;

@end

@protocol DataConsumerListener <NSObject>

/*!
    @brief Executed when the underlying DataChannel is connecting
    @param consumer The consumer instance executing this method
 */
-(void)onConnecting:(DataConsumer *)consumer;
/*!
    @brief Executed when the underlying DataChannel is open
    @param consumer The consumer instance executing this method
 */
-(void)onOpen:(DataConsumer *)consumer;
/*!
    @brief Executed when the underlying DataChannel is closing
    @param consumer The consumer instance executing this method
 */
-(void)onClosing:(DataConsumer *)consumer;
/*!
    @brief Executed when the underlying DataChannel is closed for unknown reasons
    @param consumer The consumer instance executing this method
 */
-(void)onClose:(DataConsumer *)consumer;
/*!
    @brief Executed when the transport this consumer belongs to is closed for whatever reason. The consumer itself is also closed
    @param consumer The consumer instance executing this method
 */
-(void)onTransportClose:(DataConsumer *)consumer;
/*!
    @brief Executed when a DataChannel message is received
    @param consumer The consumer instance executing this method
    @param buffer Data message received
 */
-(void)onMessage:(DataConsumer *)consumer buffer:(NSData *)buffer;

@end


#endif /* DataConsumer_h */
