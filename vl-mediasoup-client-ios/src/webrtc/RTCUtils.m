//
//  RTCUtils.m
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "RTCUtils.h"
#import <WebRTC/RTCRtpEncodingParameters.h>


@implementation RTCUtils : NSObject

+(RTCRtpEncodingParameters *)genRtpEncodingParameters:(BOOL)isActive maxBitrateBps:(NSInteger)maxBitrateBps minBitrateBps:(NSInteger)minBitrateBps maxFramerate:(NSInteger)maxFramerate numTemporalLayers:(NSInteger)numTemporalLayers scaleResolutionDownBy:(NSInteger)scaleResolutionDownBy {
    RTCRtpEncodingParameters *encoding = [[RTCRtpEncodingParameters alloc] init];
    encoding.isActive = isActive;
    encoding.maxBitrateBps = [NSNumber numberWithInt:maxBitrateBps];
    encoding.minBitrateBps = [NSNumber numberWithInt:minBitrateBps];
    encoding.maxFramerate = [NSNumber numberWithInt:maxFramerate];
    encoding.numTemporalLayers = [NSNumber numberWithInt:numTemporalLayers];
    encoding.scaleResolutionDownBy = [NSNumber numberWithInt:scaleResolutionDownBy];
    
    return [encoding autorelease];
}

@end
