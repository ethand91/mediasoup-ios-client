#include "MediasoupClient.h"
#include "DeviceWrapper.h"

const char *initialize()
{
    return "Test";
}

const DeviceWrapper * createDevice()
{
    return [[DeviceWrapper alloc] init];
}
