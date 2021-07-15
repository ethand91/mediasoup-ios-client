//
//  Mediasoupclient.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "Mediasoupclient.h"
#import "MediasoupclientWrapper.h"

@implementation Mediasoupclient
+(NSString *)version {
    return [MediasoupclientWrapper nativeVersion];
}
@end
