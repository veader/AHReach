# AHReach

## What?

AHReach is a simple reachability library for iOS. It covers roughly the same ground as the Reachability sample code written by Apple, but has a block-based API for notifying client code of changes and an explicitly liberal (MIT) license. It is also written with ARC projects in mind.

AHReach allows you to monitor for changes in network availability. This means you can preemptively notify your users when the device's connection is down, or when particular servers might not be available.

## How?

AHReach uses the SystemConfiguration framework (in particular, the SCNetworkReachability API) to listen for changes in network availability and interface switchover (WiFi to WWAN, for example).

You can incorporate AHReach into your project by copy-pasting `AHReach.h` and `AHReach.m` into your project. You will also need to link against `SystemConfiguration.framework` if you aren't already.

## Specific Examples

### How to detect if the default host is reachable via any interface

	AHReach *defaultHostReach = [AHReach reachForDefaultHost];
	[defaultHostReach startUpdatingWithBlock:^(AHReach *reach) {
		if([reach isReachable])
			NSLog(@"Can reach default host");
	}];
	
### How to detect if an arbitrary Internet address is reachable via WiFi

	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(struct sockaddr_in));
	addr.sin_len = sizeof(struct sockaddr_in);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(80);	
	inet_aton("173.194.43.0", &addr.sin_addr);

	AHReach *addressReach = [AHReach reachForAddress:&addr];
	[addressReach startUpdatingWithBlock:^(AHReach *reach) {
		if([reach isReachableViaWiFi])
			NSLog(@"Can reach Google via WiFi");
	}];

See the sample project for more examples.
