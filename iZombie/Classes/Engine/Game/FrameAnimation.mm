//
//  FrameAnimation.mm
//  iEngine
//
//  Created by Safiul Azam on 7/1/09.
//  Copyright 2009 None. All rights reserved.
//

#import "FrameAnimation.h"


@implementation FrameAnimation

- (id) initWithFrameSequence:(NSArray *) frameSequence :(NSInteger) frameInterval 
{
	[super init];
	
	_frameIndex = 0;
	
	_frameSequence = [frameSequence retain];
	
	_frameInterval = frameInterval;
		
	_lastTimeMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
		
	return self;
}

- (NSArray *) getFrameSequence 
{
	return _frameSequence;
}

- (NSInteger) getFrameInterval 
{
	return _frameInterval;
}

- (NSInteger) getFrameIndex 
{
	if(_frameInterval >= 0)
		if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _lastTimeMilliseconds > _frameInterval) {
			
			_frameIndex = (_frameIndex < [self getCountFrameSequence] - 1) ? _frameIndex + 1 : 0;
			
			_lastTimeMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
		}
	
	return _frameIndex;
}

- (NSInteger) getCountFrameSequence 
{
	return [_frameSequence count];
}

- (NSInteger) getFrame 
{
	return [(NSNumber *) [_frameSequence objectAtIndex:[self getFrameIndex]] intValue];
}

- (void) reset
{
	_frameIndex = 0;
	_lastTimeMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
}

- (void) dealloc 
{
	[_frameSequence release];
    
    [[LogUtility getInstance] printMessage:@"FrameAnimation - dealloc"];
	
	[super dealloc];
}

@end
