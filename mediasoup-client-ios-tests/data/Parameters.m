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
    return [self generateRouterRtpCapabilities:true includeAudio:true];
}

+(NSString *)generateRouterRtpCapabilities:(bool)includeVideo includeAudio:(bool)includeAudio {
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
    
    NSArray* codecs;
    
    if (includeAudio && includeVideo) {
        codecs = @[audioCodec, videoCodec, rtxCodec];
    } else if (!includeAudio && includeVideo) {
        codecs = @[videoCodec, rtxCodec];
    } else {
        codecs = @[audioCodec];
    }
    
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

+(NSDictionary *)generateTransportRemoteParameters {
    NSDictionary *fingerprint1 = @{
        @"algorithm": @"sha-266",
        @"value": @"A9:F4:E0:D2:74:D3:0F:D9:CA:A5:2F:9F:7F:47:FA:F0:C4:72:DD:73:49:D0:3B:14:90:20:51:30:1B:90:8E:71"
    };
    
    NSDictionary *fingerprint2 = @{
        @"algorithm": @"sha-384",
        @"value": @"03:D9:0B:87:13:98:F6:6D:BC:FC:92:2E:39:D4:E1:97:32:61:30:56:84:70:81:6E:D1:82:97:EA:D9:C1:21:0F:6B:C5:E7:7F:E1:97:0C:17:97:6E:CF:B3:EF:2E:74:B0"
    };
    
    NSDictionary *fingerprint3 = @{
        @"algorithm": @"sha-512",
        @"value": @"84:27:A4:28:A4:73:AF:43:02:2A:44:68:FF:2F:29:5C:3B:11:9A:60:F4:A8:F0:F5:AC:A0:E3:49:3E:B1:34:53:A9:85:CE:51:9B:ED:87:5E:B8:F4:8E:3D:FA:20:51:B8:96:EE:DA:56:DC:2F:5C:62:79:15:23:E0:21:82:2B:2C"
    };
    
    NSArray *fingerprintsArray = @[fingerprint1, fingerprint2, fingerprint3];
    
    NSDictionary *dtlsParameters = @{
        @"role": @"auto",
        @"fingerprints": fingerprintsArray
    };
    
    NSDictionary *iceCandidate1 = @{
        @"family": @"ipv4",
        @"foundation": @"udpcandidate",
        @"ip": @"9.9.9.9",
        @"port": @40032,
        @"priority": @1078862079,
        @"protocol": @"udp",
        @"type": @"host"
    };
    
    NSDictionary *iceCandidate2 = @{
        @"family": @"ipv6",
        @"foundation": @"udpcandidate",
        @"ip": @"9:9:9:9:9:9",
        @"port": @41443,
        @"priority": @104232353,
        @"protocol": @"udp",
        @"type": @"host"
    };
    
    NSArray *iceCandidatesArray = @[iceCandidate1, iceCandidate2];
    
    NSDictionary *iceParameters = @{
        @"iceLite": @true,
        @"password": @"dsadasudas7943nksafjsa",
        @"usernameFragment": @"h24tdsdgsdges"
    };
    
    NSDictionary *transportRemoteParameters = @{
        @"id": [[NSUUID UUID] UUIDString],
        @"dtlsParameters": dtlsParameters,
        @"iceCandidates": iceCandidatesArray,
        @"iceParameters": iceParameters
    };
    
    return transportRemoteParameters;
}

+(NSString *)generateIceServers {
    NSDictionary *stunServer = @{
        @"urls": @"stun:stun.example.org"
    };
    
    NSDictionary *turnServer = @{
        @"urls": @"turn:turnserver.example.org",
        @"username": @"mediasoup",
        @"credential": @"password"
    };
    
    NSArray *iceServersArray = @[stunServer, turnServer];
    
    // Convert to json string
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:iceServersArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+(NSDictionary *)generateConsumerRemoteParameters {
    NSDictionary *opusParameters = @{
        @"useinbandfec": @1
    };
    
    NSDictionary *opusCodec = @{
        @"mimeType": @"audio/opus",
        @"clockRate": @"48000",
        @"payloadType": @100,
        @"channels": @2,
        @"rtcpFeedback": @[],
        @"parameters": opusParameters
    };
    
    NSArray *opusArray = @[opusCodec];
    
    NSDictionary *encodingsObject = @{
        @"ssrc": @22222222
    };
    
    NSArray *encodings = @[encodingsObject];
    
    NSDictionary *headerExtensionsObject = @{
        @"uri": @"urn:ietf:params:rtp-hdrext:ssrc-audio-level",
        @"id": @1
    };
    
    NSArray *headerExtensions = @[headerExtensionsObject];
    
    NSDictionary *rtcpObject = @{
        @"cname": [[NSUUID UUID] UUIDString],
        @"reducedSize": @true,
        @"mux": @true
    };
    
    NSDictionary *rtpParameters = @{
        @"codecs": opusArray,
        @"encodings": encodings,
        @"headerExtensions": headerExtensions,
        @"rtcp": rtcpObject
    };
    
    NSDictionary *remoteParameters = @{
        @"producerId": @"producer",
        @"id": @"consumer",
        @"kind": @"audio",
        @"rtpParameters": rtpParameters
    };
    
    return remoteParameters;
}

@end
