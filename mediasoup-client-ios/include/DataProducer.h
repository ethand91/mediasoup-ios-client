//
//  DataProducer.h
//  mediasoup-client-ios
//
//  Created by Simon Pickup.
//  Copyright © 2022 Simon Pickup. All rights reserved.
//

#ifndef DataProducer_h
#define DataProducer_h

@interface DataProducer : NSObject
/*! @brief libmediasoupclient native data producer object */
@property(nonatomic, strong) NSValue* _nativeProducer;

/*! @return Producer identifier */
-(NSString *)getId;
/*! @return The SCTP stream parameters */
-(NSString *)getSctpStreamParameters;
/*! @return The DataChannel ready state */
-(NSString *)getReadyState;
/*! @return The DataChannel label */
-(NSString *)getLabel;
/*! @return The DataChannel sub-protocol */
-(NSString *)getProtocol;
/*! @return The number of bytes of application data (UTF-8 text and binary data) that have been queued using send() */
-(uint64_t)getBufferedAmount;
/*! @return Custom data Object provided by the application in the data producer factory method. The app can modify its content at any time */
-(NSString *)getAppData;
/*! @return Whether the producer is closed */
-(bool)isClosed;
/*!
    @brief Closes the data producer. No more data is transmitted
 */
-(void)close;
/*!
    @brief Sends the given data over the corresponding DataChannel
    @param buffer Data message to be sent
 */
-(void)send:(NSData *)buffer;

@end

@protocol DataProducerListener <NSObject>

/*!
    @brief Executed when the underlying DataChannel is open
    @param producer The producer instance executing this method
 */
-(void)onOpen:(DataProducer *)producer;
/*!
    @brief Executed when the underlying DataChannel is closed for unknown reasons
    @param producer The producer instance executing this method
 */
-(void)onClose:(DataProducer *)producer;
/*!
    @brief Executed when the DataChannel buffered amount of bytes changes
    @param producer The producer instance executing this method
    @param sentDataSize The amount of data sent
 */
-(void)onBufferedAmountChange:(DataProducer *)producer sentDataSize:(uint64_t)sentDataSize;
/*!
    @brief Executed when the transport this producer belongs to is closed for whatever reason. The producer itself is also closed
    @param producer The producer instance executing this method
 */
-(void)onTransportClose:(DataProducer *)producer;

@end

#endif /* DataProducer_h */
