//
//  Transport.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Transport_h
#define Transport_h

@interface Transport : NSObject
/*! @brief libmediasoupclient Transport object */
@property(nonatomic, strong) NSValue* _nativeTransport;

/*!
    @brief Transport identifier. It matches the id of the server side transport
    @return Transport Identifier
 */
-(NSString *)getId;
/*!
    @brief The current connection state of the local peerconnection
    @return local peerconnection connection state
 */
-(NSString *)getConnectionState;
/*!
    @brief Custom data object provided by the applicaton in the transport contructor.
    @return Custom data object
 */
-(NSString *)getAppData;
/*!
    @brief Gets the local transport statistics by calling getStats() in the underlying RTCPeerConnection instance
    @return Local transport statistics
 */
-(NSString *)getStats;
/*!
    @return Whether the transport is closed
 */
-(bool)isClosed;
/*!
    @brief Instructs the undelying peerconnection to restart ICE by providing it with new remote ICE parameters
    @param iceParameters New ICE parameters of the server side transport
 */
-(void)restartIce:(NSString *)iceParameters;
/*!
    @brief Provides the underlying peerconnection with a new list of TURN servers
    @param iceServers List of TURN servers to provide the local peerconnection with
 */
-(void)updateIceServers:(NSString *)iceServers;
/*! @brief Closes the transport, including all its producers and consumers */
-(void)close;

@end

@protocol TransportListener <NSObject>

@required
/*!
    @brief Called when the transport is about to establish the ICE+DTLS connection and needs to exchange information with the associated server side transport
    @param transport Transport instance
    @param dtlsParameters Local DTLS parameters
 */
-(void)onConnect:(Transport *)transport dtlsParameters:(NSString *)dtlsParameters;
/*!
    @brief Emitted when the local transport connection state changes
    @param transport Transport instance
    @param connectionState Transport connection state
 */
-(void)onConnectionStateChange:(Transport *)transport connectionState:(NSString *)connectionState;

@end

#endif /* Transport_h */
