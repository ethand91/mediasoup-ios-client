//
//  Producer.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <WebRTC/RTCMediaStreamTrack.h>
#import <WebRTC/RTCPeerConnectionFactory.h>

#ifndef Producer_h
#define Producer_h

@interface Producer : NSObject
/*! @brief libmediasoupclient native producer object */
@property(nonatomic, strong) NSValue* _nativeProducer;
/*! @brief Producer native track */
@property(nonatomic, strong) RTCMediaStreamTrack *_nativeTrack;

/*! @return Producer identifier */
-(NSString *)getId;
/*! @return Whether the producer is closed */
-(bool)isClosed;
/*! @return The media kind (video or audio) */
-(NSString *)getKind;
/*! @return The audio or video track being transmitted */
-(RTCMediaStreamTrack *)getTrack;
/*! @return Whether the producer is paused */
-(bool)isPaused;
/*! @return In case of simulcast, this value determines the highest stream (from 0 to N-1) being transmitted */
-(int)getMaxSpatialLayer;
/*! @return Custom data object provided by the application in the producer factory method */
-(NSString *)getAppData;
/*! @return Producer RTP parameters */
-(NSString *)getRtpParameters;
/*!
    @brief Resumes the producer (no RTP is sent again to the server)
 */
-(void)resume;
/*!
   @brief Pauses the producer (no RTP is sent to the server)
*/
-(void)pause;
/*!
    @brief In case of simulcast, this method limits the highest RTP stream being transmitted to the server
    @param layer The index of the entry in encodings representing the highest RTP stream that will be transmitted
 */
-(void)setMaxSpatialLayers:(int)layer;
/*!
    @brief Replaces the audio or video track being transmitted. No negotitation with the server is needed
    @param track An audio or video track
 */
-(void)replaceTrack:(RTCMediaStreamTrack *)track;
/*!
    @brief Gets the local RTP sender statistics by calling getStats() in the underlying RTCRtpSender instance
 */
-(NSString *)getStats;
/*!
    @brief Closes the producer. No more media is transmitted
 */
-(void)close;

@end

@protocol ProducerListener <NSObject>

/*!
    @brief Executed when the transport this producer belongs to is closed for whatever reason. The producer itself is also closed
    @param producer The producer instance executing this method
 */
-(void)onTransportClose:(Producer *)producer;

@end

#endif /* Producer_h */
