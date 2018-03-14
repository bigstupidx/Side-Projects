//
//  FrameAnimation.h
//  iEngine
//
//  Created by Safiul Azam on 7/1/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimeUtility.h"
#import "Element.h"
#import "LogUtility.h"

@interface FrameAnimation : Element 
{
	@private
	NSArray *_frameSequence;
	NSInteger _frameIndex;
	NSInteger _frameInterval;
	
	long _lastTimeMilliseconds;
}

- (id) initWithFrameSequence:(NSArray *) frameSequence :(NSInteger) frameInterval;

- (NSArray *) getFrameSequence;

- (NSInteger) getFrameInterval;

- (NSInteger) getFrameIndex;

- (NSInteger) getCountFrameSequence;

- (NSInteger) getFrame;

- (void) reset;

@end
