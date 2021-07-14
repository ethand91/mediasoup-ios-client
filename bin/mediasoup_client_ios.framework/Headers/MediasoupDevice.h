//
//  Device.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactoryOptions.h>

#import "SendTransport.h"
#import "RecvTransport.h"

#ifndef MediasoupDevice_h
#define MediasoupDevice_h

@interface MediasoupDevice : NSObject
/*! @brief libmediasoupclient native device object */
@property(nonatomic, strong) NSValue* _nativeDevice;

/*!
    @brief Creates a new libmediasoupclient device object
    @return New libmediasoupclient device object
 */
-(id)init;
/*! @brief Destroys the libmediasoupclient device */
-(void)dispose;
/*!
    @brief Loads the device with the RTP capabilities of the mediasoup router
    @discussion This method takes the RTP capabilities of the mediasoup router and works out what media codecs to use etc.
    @param routerRtpCapabilities mediasoup router RTP capabilities
 */
-(void)load:(NSString *)routerRtpCapabilities;
/*!
    @brief Checks whether the device has been loaded
    @return Whether the device has been loaded or not
 */
-(bool)isLoaded;
/*!
    @brief Returns the loaded RTP capabilities of the device
    @returns Device's RTP capabilities
    @throws The device has not been loaded
 */
-(NSString *)getRtpCapabilities;
/*!
    @brief Returns the devices sctpCapabilities
    @returns Devices SCTP Capabilities
    @throws The device has not been loaded
 */
-(NSString *)getSctpCapabilities;
/*!
    @brief Returns whether the device can produce media of the given kind
    @discussion This depends on the media codecs enabled in the mediasoup router and the media capabilities of libwebrtc
    @return Whether the device can produce the given media type or not
 */
-(bool)canProduce:(NSString *)kind;
/*!
    @brief Creates a new WebRTC transport to send media
    @discussion The transport must be previously created in the mediasoup router
    @param listener SendTransportListener delegate
    @param id The identifier of the server side transport
    @param iceParameters ICE parameters of the server side transport
    @param iceCandidates ICE candidates of the server side transport
    @param dtlsParameters DTLS parameters of the server side transport
    @return SendTransport
 */
-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters;
/*!
   @brief Creates a new WebRTC transport to <b>send</b> media
   @discussion The transport must be previously created in the mediasoup router
   @param listener SendTransportListener delegate
   @param id The identifier of the server side transport
   @param iceParameters ICE parameters of the server side transport
   @param iceCandidates ICE candidates of the server side transport
   @param dtlsParameters DTLS parameters of the server side transport
   @param sctpParameters SCTP parameters of the server side transport
   @param options PeerConnection options
   @param appData Custom application data
   @return SendTransport
*/
-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
/*!
    @brief Creates a new WebRTC transport to <b>receive</b> media
    @discussion The transport must be previously created in the mediasoup router
    @param listener SendTransportListener delegate
    @param id The identifier of the server side transport
    @param iceParameters ICE parameters of the server side transport
    @param iceCandidates ICE candidates of the server side transport
    @param dtlsParameters DTLS parameters of the server side transport
    @return RecvTransport
 */
-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters;
/*!
   @brief Creates a new WebRTC transport to <b>receive</b> media
   @discussion The transport must be previously created in the mediasoup router
   @param listener SendTransportListener delegate
   @param id The identifier of the server side transport
   @param iceParameters ICE parameters of the server side transport
   @param iceCandidates ICE candidates of the server side transport
   @param dtlsParameters DTLS parameters of the server side transport
   @param sctpParameters SCTP parameters of the server side transport
   @param options PeerConnection options
   @param appData Custom application data
   @return RecvTransport
*/
-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData;
@end

#endif /* Device_h */
