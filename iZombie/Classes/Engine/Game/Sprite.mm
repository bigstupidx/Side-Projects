//
//  Sprite.mm
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

-(id) initWithSize:(CGSize) size {
	
	[super initWithSize:size];
    
	_frameSets = [[NSMutableArray alloc] init];
	
	_frameAnimations = [[NSMutableArray alloc] init];
	
	_activeFrameAnimationIndex = 0;
		
	return self;
}

-(NSArray *) getFrameSets {

	return _frameSets;
}

-(NSInteger) getCountFrameSets {

	return [_frameSets count];
}

-(NSInteger) getFrameSetIndex:(FrameSet *) frameSet {

	return [_frameSets indexOfObject:frameSet];
}

-(FrameSet *) getFrameSet:(NSInteger) index {

	return [_frameSets objectAtIndex:index];
}

-(void) addFrameSet:(FrameSet *) frameSet {

	[_frameSets addObject:frameSet];
}

-(void) replaceFrameSet:(NSInteger) index :(FrameSet *) frameSet {
	
	FrameSet *temporaryFrameSet= [_frameSets objectAtIndex:index];
	
	[_frameSets replaceObjectAtIndex:index withObject:frameSet];
	
	[temporaryFrameSet release];
}

-(void) removeFrameSet:(FrameSet *) frameSet {

	[_frameSets removeObject:frameSet];
}

-(void) removeAllFrameSets {

	[_frameSets removeAllObjects];
}

-(NSArray *) getFrameAnimations {

	return _frameAnimations;
}

-(NSInteger) getCountFrameAnimations {

	return [_frameAnimations count];
}

-(NSInteger) getFrameAnimationIndex:(FrameAnimation *) frameAnimation {

	return [_frameAnimations indexOfObject:frameAnimation];
}

-(NSInteger) getFrameAnimationIndexByName:(NSString *) name {
    
    for(int i = 0; i < [[self getFrameAnimations] count]; i++)
    {
        FrameAnimation *frameAnimation = [[self getFrameAnimations] objectAtIndex:i];
        if([frameAnimation getName] == name)
            return i;
    }
    
    return -1;
}

-(FrameAnimation *) getFrameAnimation:(NSInteger) index {

	return [_frameAnimations objectAtIndex:index];
}

-(void) addFrameAnimation:(FrameAnimation *) frameAnimation {

	[_frameAnimations addObject:frameAnimation];
}

-(void) replaceFrameAnimation:(NSInteger) index :(FrameAnimation *) frameAnimation {

	FrameAnimation *temporaryFrameAnimation = [_frameAnimations objectAtIndex:index];
	
	[_frameAnimations replaceObjectAtIndex:index withObject:frameAnimation];
	
	[temporaryFrameAnimation release];
}

-(void) removeFrameAnimation:(FrameAnimation *) frameAnimation {

	[_frameAnimations removeObject:frameAnimation];
}

-(void) removeAllFrameAnimations {

	[_frameAnimations removeAllObjects];
}

-(NSInteger) getActiveFrameAnimationIndex {

	return _activeFrameAnimationIndex;
}

-(void) setActiveFrameAnimationIndex:(NSInteger) index {

	_activeFrameAnimationIndex = index;
}

-(FrameAnimation *) getActiveFrameAnimation {
	
	return [self getFrameAnimation:_activeFrameAnimationIndex];
}

-(BOOL) isCollideWith:(Sprite *) with
{
    CGPoint center = [self getCenter];
    CGSize size = [self getSize];
    
    CGPoint withCenter = [with getCenter];
    CGSize withSize = [with getSize];
    
    if(center.x - size.width / 6 >= withCenter.x + withSize.width / 6)
        return NO;
    else if(center.x + size.width / 6 < withCenter.x - withSize.width / 6)
        return NO;
    else if(center.y - size.height / 6 >= withCenter.y + withSize.height / 6)
        return NO;
    else if(center.y + size.height / 6 < withCenter.y - withSize.height / 6)
        return NO;
    
    return YES;
}

-(BOOL) isTouchWith:(CGPoint) with
{
    CGPoint center = [self getCenter];
    CGSize size = [self getSize];
    
    if(with.x < center.x - size.width / 2)
        return NO;
    else if(with.x >= center.x + size.width / 2)
        return NO;
    else if(with.y < center.y - size.height / 2)
        return NO;
    else if(with.y >= center.y + size.height / 2)
        return NO;
    
    return YES;
}

-(void) draw {

	if(![self isVisible])
		return;
	
	[super draw];
	
	if([self getCountFrameSets] <= 0)
		return;
	else if([self getCountFrameAnimations] <= 0)
		return;
		
	glPushMatrix();
	glTranslatef([self getCenter].x, [self getCenter].y, 0.0);	
	
	// Flip.
	if([self getFlip] != FlipNone) {
		
		if([self getFlip] == FlipHorizontal)
			glRotatef(180.0, 0.0, 1.0, 0.0);
		else if([self getFlip] == FlipVertical)
			glRotatef(180.0, 1.0, 0.0, 0.0);
		else {
			
			glRotatef(180.0, 0.0, 1.0, 0.0);
			glRotatef(180.0, 1.0, 0.0, 0.0);
		}
	}
	
	glScalef([self getScale].x, [self getScale].y, 0);
	glRotatef([self getRotate], 0.0, 0.0, 1.0);
		
	for(NSInteger i = 0; i < [self getCountFrameSets]; i++) {
	
		FrameSet *frameSet = [self getFrameSet:i];
		
		NSInteger index = [[self getActiveFrameAnimation] getFrame];
		
		if([frameSet isFrameExist:index]) {
            CGFloat alpha = [[frameSet getTexture] getAlpha];
            [[frameSet getTexture] setAlpha:[self getAlpha]];
			[frameSet draw:index position:CGPointMake(-[self getSize].width / 2, -[self getSize].height / 2)];
			[[frameSet getTexture] setAlpha:alpha];
            break;
		}
		else continue;
	}	
	
	for(NSInteger i = 0; i < [self getCountChilds]; i++) {
	
		Layer *child = (Layer *) [self getChild:i];
		
		[child draw];
	}
		
	glPopMatrix();	
}

-(void) dealloc {

	[_frameSets release];
	
	[_frameAnimations release];
		
	[super dealloc];
}

@end
