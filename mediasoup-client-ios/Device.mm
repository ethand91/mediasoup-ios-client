#import "Device.h"
#import "DeviceWrapper.h"

@implementation Device : NSObject

-(id)init {
    self = [super init];
    if (self) {
        self._nativeDevice = [DeviceWrapper nativeNewDevice];
    }
    
    return self;
}

-(void)load:(NSString *)routerRtpCapabilities {
    [self checkDeviceExists];
    [DeviceWrapper nativeLoad:self._nativeDevice routerRtpCapabilities:routerRtpCapabilities];
}

-(bool)isLoaded {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeIsLoaded:self._nativeDevice];
}

-(NSString *)getRtpCapabilities {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeGetRtpCapabilities:self._nativeDevice];
}

-(bool)canProduce:(NSString *)kind {
    [self checkDeviceExists];
    
    return [DeviceWrapper nativeCanProduce:self._nativeDevice kind:kind];
}

-(void)checkDeviceExists {
    if (self._nativeDevice == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"Device has been disposed." userInfo:nil];
        
        throw exception;
    }
}

@end
