//
//  Parameters.m
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/11/29.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Parameters.h"

@implementation Parameters

+(NSString *)generateRouterRtpCapabilities {
    NSDictionary *audioParameters = @{ @"useinbandfec": @"1" };
    
    NSDictionary* audioCodec = @{
        @"mimeType": @"audio/opus",
        @"kind": @"audio",
        @"clockRate": @48000,
        @"preferredPayloadType": @100,
        @"channels": @2,
        @"rtcpFeedback": @[],
        @"parameters": audioParameters
    };
    
    NSDictionary *videoParameters = @{ @"x-google-start-bitrate": @1500 };
    
    NSDictionary* videoRtcpFeedback1 = @{ @"type": @"nack" };
    NSDictionary* videoRtcpFeedback2 = @{ @"type": @"nack", @"parameter": @"pli" };
    NSDictionary* videoRtcpFeedback3 = @{ @"type": @"nack", @"parameter": @"sli" };
    NSDictionary* videoRtcpFeedback4 = @{ @"type": @"nack", @"parameter": @"rpsi" };
    NSDictionary* videoRtcpFeedback5 = @{ @"type": @"nack", @"parameter": @"app" };
    NSDictionary* videoRtcpFeedback6 = @{ @"type": @"ccm", @"parameter": @"fir" };
    NSDictionary* videoRtcpFeedback7 = @{ @"type": @"goog-remb"};
    NSArray* rtcpFeedback = @[videoRtcpFeedback1, videoRtcpFeedback2, videoRtcpFeedback3, videoRtcpFeedback4, videoRtcpFeedback5, videoRtcpFeedback6, videoRtcpFeedback7];
    
    NSDictionary* videoCodec = @{
        @"mimeType": @"video/VP8",
        @"kind": @"video",
        @"clockRate": @90000,
        @"preferredPayloadType": @101,
        @"rtcpFeedback": rtcpFeedback,
        @"parameters": videoParameters
    };
    
    NSDictionary *rtxParameters = @{ @"apt": @"101" };
    
    NSDictionary* rtxCodec = @{
        @"mimeType": @"video/rtx",
        @"kind": @"video",
        @"clockRate": @90000,
        @"preferredPayloadType": @101,
        @"rtcpFeedback": @[],
        @"parameters": rtxParameters
    };
    
    NSArray* codecs = @[audioCodec, videoCodec, rtxCodec];
    
    NSDictionary* headerEx1 = @{
        @"kind": @"audio",
        @"uri": @"urn:ietf:params:rtp-hdrext:ssrc-audio-level",
        @"preferredId": @1,
        @"preferredEncrypt": @"false",
    };
    NSDictionary* headerEx2 = @{
        @"kind": @"video",
        @"uri": @"urn:ietf:params:rtp-hdrext:offset",
        @"preferredId": @2,
        @"preferredEncrypt": @"false"
    };
    NSDictionary* headerEx3 = @{
        @"kind": @"audio",
        @"uri": @"http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time",
        @"preferredId": @3,
        @"preferredEncrypt": @"false"
    };
    NSDictionary* headerEx4 = @{
        @"kind": @"video",
        @"uri": @"http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time",
        @"preferredId": @3,
        @"preferredEncrypt": @"false"
    };
    NSDictionary* headerEx5 = @{
        @"kind": @"video",
        @"uri": @"urn:3gpp:video-orientation",
        @"preferredId": @4,
        @"preferredEncrypt": @"false"
    };
    NSDictionary* headerEx6 = @{
        @"kind": @"audio",
        @"uri": @"urn:ietf:params:rtp-hdrext:sdes:mid",
        @"preferredId": @5,
        @"preferredEncrypt": @"false"
    };
    NSDictionary* headerEx7 = @{
        @"kind": @"video",
        @"uri": @"urn:ietf:params:rtp-hdrext:sdes:mid",
        @"preferredId": @5,
        @"preferredEncrypt": @"false"
    };
    NSDictionary* headerEx8 = @{
        @"kind": @"video",
        @"uri": @"urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id",
        @"preferredId": @6,
        @"preferredEncrypt": @"false"
    };
    
    NSArray* headerExtensions = @[headerEx1, headerEx2, headerEx3, headerEx4, headerEx5, headerEx6, headerEx7, headerEx8];
    
    NSDictionary* capabilities = @{ @"codecs": codecs, @"headerExtensions": headerExtensions, @"fecMechanisms": @[] };
    
    // Convert to json string
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:capabilities options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
