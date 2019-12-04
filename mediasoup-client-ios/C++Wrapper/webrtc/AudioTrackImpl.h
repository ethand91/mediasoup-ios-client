//
//  AudioTrackImpl.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/04.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef AudioTrackImpl_h
#define AudioTrackImpl_h
#import "MediaStreamTrackImpl.h"

#import "WebRTC/RTCAudioTrack.h"

//@property(nonatomic, readonly) RTCAudioSource *source;

class AudioTrackImpl : public MediaStreamTrackImpl {
private:
    RTCAudioTrack *audioTrack;
    
public:
    AudioTrackImpl(RTCAudioTrack *audioTrack) {
        this->audioTrack = audioTrack;
    }
};

#endif /* AudioTrackImpl_h */
