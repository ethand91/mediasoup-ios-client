//
//  MediaStreamTrackImpl.h
//  mediasoup-client-ios
//
//  Created by Denvir Ethan on 2019/12/03.
//  Copyright © 2019 Denvir Ethan. All rights reserved.
//

#ifndef MediaStreamTrackImpl_h
#define MediaStreamTrackImpl_h
#include <iostream>

#import "WebRTC/RTCMediaStreamTrack.h"
//#import "rtc_base/refcount.h"

using namespace webrtc;

class MediaStreamTrackImpl : public MediaStreamTrackInterface {
private:
    RTCMediaStreamTrack *trackObject;
    
public:
    MediaStreamTrackImpl(RTCMediaStreamTrack *trackObject) {
        this->trackObject = trackObject;
    }
    
    std::string kind() const override;
    std::string id() const override;
    bool enabled() const override;
    bool set_enabled(bool enable) override;
    MediaStreamTrackInterface::TrackState state() const override;
    
    void RegisterObserver(ObserverInterface* observer) override;
    void UnregisterObserver(ObserverInterface* observer) override;
    void AddRef() const override;
    rtc::RefCountReleaseStatus Release() const override;
    
protected:
    ~MediaStreamTrackImpl() override {};
};

std::string MediaStreamTrackImpl::kind() const {
    std::cout << "kind " << std::string([this->trackObject.kind UTF8String]);
    return std::string([[this->trackObject kind] UTF8String]);
}

std::string MediaStreamTrackImpl::id() const {
    return std::string([[this->trackObject trackId] UTF8String]);
}

bool MediaStreamTrackImpl::enabled() const {
    return [this->trackObject isEnabled];
}

bool MediaStreamTrackImpl::set_enabled(bool enable) {
    return [this->trackObject isEnabled:enable];
}

MediaStreamTrackInterface::TrackState MediaStreamTrackImpl::state () const {
    RTCMediaStreamTrackState readyState = [this->trackObject readyState];
    
    return readyState == 0
        ? MediaStreamTrackInterface::TrackState::kLive
        : MediaStreamTrackInterface::TrackState::kEnded;
}

void MediaStreamTrackImpl::RegisterObserver(ObserverInterface* observer) {}
void MediaStreamTrackImpl::UnregisterObserver(ObserverInterface* observer) {}
void MediaStreamTrackImpl::AddRef() const {}
rtc::RefCountReleaseStatus MediaStreamTrackImpl::Release() const {}

#endif /* MediaStreamTrackImpl_h */
