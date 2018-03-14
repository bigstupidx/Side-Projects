//
//  DataUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataUtility.h"

static DataUtility *_dataUtility = nil;

@implementation DataUtility

- (id) init 
{
	[super init];
	
	return self;
}

+ (DataUtility *) getInstance 
{
	if(_dataUtility == nil)
		_dataUtility = [[DataUtility alloc] init];
	
	return _dataUtility;
}

- (NSString *) getBase64EncodedString:(NSString *) string
{
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
	return [data base64EncodedString];
}

- (NSString *) getBase64DecodedString:(NSString *) string
{
    NSData *data = [NSData dataFromBase64String:string];
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

- (void) dealloc 
{
	[super dealloc];
}

@end
