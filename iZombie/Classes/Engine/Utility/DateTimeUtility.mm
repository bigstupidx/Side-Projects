//
//  DateTimeUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateTimeUtility.h"

static DateTimeUtility *_dateTimeUtility = nil;

@implementation DateTimeUtility

- (id) init 
{
	[super init];
    
	_currentTimeMillisecondsOffset = 0.0;
	_currentTimeMillisecondsSpeed = 1.0;
	
	return self;
}

+ (DateTimeUtility *) getInstance 
{
	if(_dateTimeUtility == nil)
		_dateTimeUtility = [[DateTimeUtility alloc] init];
	
	return _dateTimeUtility;
}

- (NSString *) getDateTime:(NSString *) format
{
    if(format == nil)
        format = @"yyyy-MM-dd HH:MM:SS";
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:[NSDate date]];
}

- (long) getCurrentTimeMillisecondsOffset
{
	return _currentTimeMillisecondsOffset;
}

- (void) setCurrentTimeMillisecondsOffset:(long) offset
{
	_currentTimeMillisecondsOffset = offset;
}

- (CGFloat) getCurrentTimeMillisecondsSpeed
{
	return _currentTimeMillisecondsSpeed;
}

- (void) setCurrentTimeMillisecondsSpeed:(CGFloat) speed
{
	_currentTimeMillisecondsSpeed = speed;
}

- (long) getCurrentTimeMilliseconds
{
	struct timeb current;
	
	ftime( &current);
	
	long currentTimeMilliseconds = (current.time & 0xfffff) * 1000 + current.millitm;	
	currentTimeMilliseconds += [[DateTimeUtility getInstance] getCurrentTimeMillisecondsOffset];
	currentTimeMilliseconds *= [[DateTimeUtility getInstance] getCurrentTimeMillisecondsSpeed];
	
	return (long) currentTimeMilliseconds;
}

- (void) dealloc 
{
	[super dealloc];
}

@end
