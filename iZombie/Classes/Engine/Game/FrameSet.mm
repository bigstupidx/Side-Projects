//
//  FrameSet.mm
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import "FrameSet.h"


@implementation FrameSet

- (id) initWithFirstFrameIndex:(NSInteger) firstFrameIndex :(CGSize) frameSize :(Texture *) texture 
{
	_firstFrameIndex = firstFrameIndex;
	_frameSize = frameSize;
	_texture = texture;
	
	return self;
}

-(NSInteger) getFirstFrameIndex 
{
	return _firstFrameIndex;
}

- (CGSize) getFrameSize 
{
	return _frameSize;
}

-(Texture *) getTexture 
{
	return _texture;
}

-(NSInteger) getCountFrames 
{
	NSInteger columns = [[self getTexture] getSize].width / [self getFrameSize].width;
	NSInteger rows = [[self getTexture] getSize].height / [self getFrameSize].height;
	
	return columns * rows;
}

-(BOOL) isFrameExist:(NSInteger) index 
{
	if(index < [self getFirstFrameIndex] || index > [self getFirstFrameIndex] + [self getCountFrames] - 1)
		return NO;
	
	return YES;
}

-(void) draw:(NSInteger) frameIndex position:(CGPoint) position 
{
	if(![self isFrameExist:frameIndex])
		return;
	
	frameIndex -= [self getFirstFrameIndex];
	
	CGFloat x = ((GLint) frameIndex % (GLint) ([[self getTexture] getSize].width / ([self getFrameSize].width))) * ([self getFrameSize].width);
	CGFloat y = ((GLint) frameIndex / (GLint) ([[self getTexture] getSize].width / ([self getFrameSize].width))) * ([self getFrameSize].height);
		
	CGFloat width = [self getFrameSize].width;
	CGFloat height = [self getFrameSize].height;
		
	[[self getTexture] draw:position :CGRectMake(x, y, width, height)];
}

- (void) dealloc 
{
    [[LogUtility getInstance] printMessage:@"FrameSet - dealloc"];
    
	[super dealloc];
}

@end
