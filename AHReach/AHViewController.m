//
//  AHViewController.m
//
//  Copyright (c) 2012 Auerhaus Development, LLC
//  
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included 
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
//  IN THE SOFTWARE.
//  

#import "AHViewController.h"
#import "AHReach.h"

@interface AHViewController ()
@property(nonatomic, strong) IBOutlet UITextField *defaultHostField;
@property(nonatomic, strong) IBOutlet UITextField *hostField;
@property(nonatomic, strong) IBOutlet UITextField *addressField;
@property(nonatomic, strong) NSArray *reaches;
@end

@implementation AHViewController

@synthesize defaultHostField, hostField, addressField, reaches;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	defaultHostField.text = @"<No updates yet>";
	hostField.text = @"<No updates yet>";
	addressField.text = @"<No updates yet>";
	
	AHReach *defaultHostReach = [AHReach reachForDefaultHost];
	[defaultHostReach startUpdatingWithBlock:^(AHReach *reach) {
		[self updateAvailabilityField:self.defaultHostField withReach:reach];
	}];
	[self updateAvailabilityField:self.defaultHostField withReach:defaultHostReach];
	
	AHReach *hostReach = [AHReach reachForHost:@"auerhaus.com"];
	[hostReach startUpdatingWithBlock:^(AHReach *reach) {
		[self updateAvailabilityField:self.hostField withReach:reach];
	}];
	[self updateAvailabilityField:self.hostField withReach:hostReach];

	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(struct sockaddr_in));
	addr.sin_len = sizeof(struct sockaddr_in);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(80);	
	inet_aton("173.194.43.0", &addr.sin_addr);

	AHReach *addressReach = [AHReach reachForAddress:&addr];
	[addressReach startUpdatingWithBlock:^(AHReach *reach) {
		[self updateAvailabilityField:self.addressField withReach:reach];
	}];
	[self updateAvailabilityField:self.addressField withReach:addressReach];
	
	self.reaches = [NSArray arrayWithObjects:defaultHostReach, hostReach, addressReach, nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateAvailabilityField:(UITextField *)field withReach:(AHReach *)reach {
	field.text = @"Not reachable";
	
	if([reach isReachableViaWWAN])
		field.text = @"Available via WWAN";
	
	if([reach isReachableViaWiFi])
		field.text = @"Available via WiFi";
}

@end
