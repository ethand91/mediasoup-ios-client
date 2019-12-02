#import <Foundation/Foundation.h>
#import "Producer.h"
#import "ProducerWrapper.h"

@implementation Producer : NSObject

-(id)initWithNativeProducer:(NSObject *)nativeProducer {
    self = [super init];
    if (self) {
        self._nativeProducer = nativeProducer;
    }
    
    return self;
}

-(NSString *)getId {
    return [ProducerWrapper getNativeId:self._nativeProducer];
}

-(bool)isClosed {
    return [ProducerWrapper isNativeClosed:self._nativeProducer];
}

-(NSString *)getKind {
    return [ProducerWrapper getNativeKind:self._nativeProducer];
}

-(RTCMediaStreamTrack *)getTrack {
    return (RTCMediaStreamTrack *)[ProducerWrapper getNativeTrack:self._nativeProducer];
}

-(bool)isPaused {
    return [ProducerWrapper isNativePaused:self._nativeProducer];
}

-(int)getMaxSpatialLayer {
    return [ProducerWrapper getNativeMaxSpatialLayer:self._nativeProducer];
}

-(NSString *)getAppData {
    return [ProducerWrapper getNativeAppData:self._nativeProducer];
}

-(NSString *)getRtpParameters {
    return [ProducerWrapper getNativeRtpParameters:self._nativeProducer];
}

-(void)resume {
    [ProducerWrapper nativeResume:self._nativeProducer];
}

-(void)pause {
    [ProducerWrapper nativePause:self._nativeProducer];
}

-(void)setMaxSpatialLayers:(int)layer {
    [ProducerWrapper setNativeMaxSpatialLayer:self._nativeProducer layer:layer];
}

-(void)replaceTrack:(RTCMediaStreamTrack *)track {
    NSObject *nativeMediaStreamTrack = reinterpret_cast<NSObject *>(track);
    
    [ProducerWrapper nativeReplaceTrack:self._nativeProducer track:nativeMediaStreamTrack];
}

-(NSString *)getStats {
    return [ProducerWrapper getNativeStats:self._nativeProducer];
}

-(void)close {
    [ProducerWrapper nativeClose:self._nativeProducer];
}

@end
