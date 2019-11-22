#import <Foundation/Foundation.h>

#import "Transport.hpp"

@interface TransportWrapper : NSObject
@property(nonatomic, readonly)NSString *id;
@property(nonatomic, readonly)NSObject *iceParameters;
@property(nonatomic, readonly)NSObject *iceCandidates;
@property(nonatomic, readonly)NSObject *dtlsParameters;
@property(nonatomic, readonly)NSObject *peerConnectionOptions;
@property(nonatomic, readonly)NSObject *extendedRtpCapabilities;
@property(nonatomic, readonly)NSObject *canProduceByKind;
@property(nonatomic, readonly)NSObject *appData;
@end

@interface TransportWrapper ()
@property(atomic, readonly, assign) mediasoupclient::Transport *transport;
@end

@implementation TransportWrapper
@synthesize transport = _transport;

-(NSString *)getNativeId {
    return [NSString stringWithUTF8String:self.transport->GetId().c_str()];
}

@end
