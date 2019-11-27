cmake_minimum_required(VERSION 3.5)

#project(mediasoupclient_ios LANGUAGES CXX)

# Set version number
#set(mediasoupclient_ios_VERSION_MAJOR 3)
#set(mediasoupclient_ios_VERSION_MINOR 0)
#set(mediasoupclient_ios_VERSION_PATCH 4)

# C++ requirements
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD REQUIRED ON)

# build for iphone or simulator
# default is iphone
if (NOT DEFINED MEDIASOUPCLIENT_BUILD_TARGET)
  set(SDK_NAME "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/")
else()
  set(SDK_NAME ${MEDIASOUPCLIENT_BUILD_TARGET})
endif()
message(STATUS "Building for sdk name ${SDK_NAME}")

# set mediasoup flags
set(MEDIASOUPCLIENT_LOG_TRACE ON)
set(MEDIASOUPCLIENT_LOG_DEBUG ON)
set(LIBSDPTRANSFORM_BUILD_TESTS OFF)
set(LIBSDPTRANSFORM_BUILD_READMEHELPER OFF)

# Set iOS build architectures
if (SDK_NAME STREQUAL "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/")
  set(ARCHS "arm arm64")
elseif (SDK_NAME STREQUAL "iphonesimulator")
  set(ARCHS "i366 x86_64")
else()
  message(FATAL_ERROR "Invalid MEDIASOUPCLIENT_BUILD_TARGET ${MEDIASOUPCLIENT_BUILD_TARGET}")
endif()

#set(CMAKE_OSX_SYSROOT "${SDK_NAME}" CACHE INTERNAL "")
#set(CMAKE_OSX_ARCHITECTURES ${ARCHS})
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -arch arm arm64")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch arm arm64")

set(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk")
#set(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk")
#set(CMAKE_OSX_ARCHITECTURES x86_64)
set(CMAKE_OSX_ARCHITECTURES arm64)
set(IPHONE_SDKVER "13.2")
set(IPHONE_VERSION_MIN "9.0")

# set deployment target
#set(CMAKE_OSX_DEPLOYMENT_TARGET "9.0")

# enable bitcode
set(BITCODE "-fembed-bitcode")
set(CMAKE_XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE bitcode CACHE INTERNAL "")

message(STATUS "\n========== libmediasoupclient iOS Build Configuration ==========\n")
message(STATUS "CMAKE_OSX_SYSROOT             = " ${CMAKE_OSX_SYSROOT})
message(STATUS "CMAKE_OSX_ARCHITECTURES       = " ${CMAKE_OSX_ARCHITECTURES})
message(STATUS "CMAKE_OSX_DEPLOYMENT_TARGET   = " ${CMAKE_OSX_DEPLOYMENT_TARGET})

# Source dependencies
add_subdirectory("libmediasoupclient")

# Include webrtc third party abseil-cpp
include_directories(SYSTEM "${LIBWEBRTC_INCLUDE_PATH}/third_party/abseil-cpp")
