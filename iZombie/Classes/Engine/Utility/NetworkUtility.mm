//
//  NetworkUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkUtility.h"

static NetworkUtility *_networkUtility = nil;

@implementation NetworkUtility

- (id) init 
{
	[super init];
	
	return self;
}

+ (NetworkUtility *) getInstance 
{
	if(_networkUtility == nil)
		_networkUtility = [[NetworkUtility alloc] init];
	
	return _networkUtility;
}

- (BOOL) isOnline 
{
	return ([[Reachability sharedReachability] internetConnectionStatus] != NotReachable);
}

- (void) dealloc 
{
	[super dealloc];
}

@end
