#include "Device.hpp"
#include "Exception.hpp"
#include "FakeTransportListener.hpp"
#include "catch.hpp"
#include "data/parameters.hpp"
#include "ortc.hpp"
#include <memory>

TEST_CASE("Device", "[Device]")
{
	static const json TransportRemoteParameters = generateTransportRemoteParameters();

	static FakeSendTransportListener sendTransportListener;
	static FakeRecvTransportListener recvTransportListener;

	static std::unique_ptr<Device> device(new Device());
	static json routerRtpCapabilities;

	SECTION("'device->GetHandlerName()' succeeds")
	{
		REQUIRE_NOTHROW(device->GetHandlerName());
	}

	SECTION("'device->Loaded()' is false if not loaded")
	{
		REQUIRE(!device->Loaded());
	}

	SECTION("'device->GetRtpCapabilities()' throws if not loaded")
	{
		REQUIRE_THROWS_AS(device->GetRtpCapabilities(), Exception);
	}

	SECTION("'device->CanProduce()' with audio/video throws if not loaded")
	{
		REQUIRE_THROWS_AS(device->CanProduce("audio"), Exception);
		REQUIRE_THROWS_AS(device->CanProduce("video"), Exception);
	}

	SECTION("'device->CreateSendTransport()' fails if not loaded")
	{
		REQUIRE_THROWS_AS(
		  device->CreateSendTransport(&sendTransportListener, TransportRemoteParameters), Exception);
	}

	SECTION("'device->CreateRecvTransport()' fails if not loaded")
	{
		REQUIRE_THROWS_AS(
		  device->CreateRecvTransport(&recvTransportListener, TransportRemoteParameters), Exception);
	}

	SECTION("'device->Load()' succeeds")
	{
		routerRtpCapabilities = generateRouterRtpCapabilities();

		REQUIRE_NOTHROW(device->Load(routerRtpCapabilities));
		REQUIRE(device->Loaded());
	}

	SECTION("'device->Load()' fails if already loaded")
	{
		REQUIRE_THROWS_AS(device->Load(routerRtpCapabilities), Exception);
	}

	SECTION("'device->GetRtpCapabilities()' succeeds")
	{
		REQUIRE(device->GetRtpCapabilities().is_object());
	}

	SECTION("device->CanProduce() with 'audio'/'video' kind returns true")
	{
		REQUIRE(device->CanProduce("audio"));
		REQUIRE(device->CanProduce("video"));
	}

	SECTION("device->CanProduce() with invalid kind throws exception")
	{
		REQUIRE_THROWS_AS(device->CanProduce("chicken"), Exception);
	}

	SECTION("'device->CreateSendTransport()' succeeds")
	{
		REQUIRE_NOTHROW(device->CreateSendTransport(&sendTransportListener, TransportRemoteParameters));
	}

	SECTION("'device->CreateRecvTransport()' succeeds")
	{
		REQUIRE_NOTHROW(device->CreateRecvTransport(&recvTransportListener, TransportRemoteParameters));
	}
}