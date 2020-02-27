//
//  RTCUtils.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebRTC/RTCRtpEncodingParameters.h>

#ifndef RTCUtils_h
#define RTCUtils_h

@interface RTCUtils : NSObject {}

/*!
    @brief Encoding Settings
    @param isActive Indicates that this encoding is actually sent
    @param maxBitrateBps The maximum bitrate used for this encoding
    @param minBitrateBps The minimum bitrate used for this encoding
    @param maxFramerate The maximum framerate used for this encoding
    @param numTemporalLayers The requested number of temporal layers
    @param scaleResolutionDownBy Scale the width and height down by this factor for video
 */
+(RTCRtpEncodingParameters *)genRtpEncodingParameters:(bool)isActive maxBitrateBps:(NSInteger)maxBitrateBps minBitrateBps:(NSInteger)minBitrateBps maxFramerate:(NSInteger)maxFramerate numTemporalLayers:(NSInteger)numTemporalLayers scaleResolutionDownBy:(NSInteger)scaleResolutionDownBy;

@end

#endif /* RTCUtils_h */
