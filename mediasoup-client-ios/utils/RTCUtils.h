//
//  RTCUtils.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/02.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import "WebRTC/RTCMediaStreamTrack.h"
#import "WebRTC/RTCRtpSender.h"
#import "WebRTC/RTCRtpReceiver.h"
#import "WebRTC/RTCRtpEncodingParameters.h"

#ifndef RTCUtils_h
#define RTCUtils_h

@interface RTCUtils : NSObject {}
+(long)getNativeMediaStreamTrack:(RTCMediaStreamTrack *)track;
+(long)getNativeRtpSender:(RTCRtpSender *)sender;
+(long)getNativeRtpReceiver:(RTCRtpReceiver *)receiver;
+(RTCRtpEncodingParameters *)genRtpEncodingParameters:(bool)active maxBitrateBps:(int)maxBitrateBps minBitrateBps:(int)minBitrateBps maxFramerate:(int)maxFramerate numTemporalLayers:(int)numTemporalLayers scaleResolutionDownBy:(double)scaleResolutionDownBy ssrc:(long)ssrc;
+(RTCMediaStreamTrack *)createMediaStreamTrack:(long)nativeTrack;

@end

#endif /* RTCUtils_h */
