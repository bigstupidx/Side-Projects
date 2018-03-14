//
//  Sprite.mm
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import "MovableSprite.h"

@implementation MovableSprite

-(id) initWithSize:(CGSize) size {
	
	[super initWithSize:size];
    
    _speed = 1;
    _velocity = CGPointMake(0, 0);
    _direction = 0;
    
    _path = nil;
		
	return self;
}

- (NSInteger) getSpeed
{
    return _speed;
}

- (void) setSpeed:(NSInteger) speed
{
    _speed = speed;
}

- (CGPoint) getVelocity
{
    return _velocity;
}

- (void) setVelocity:(CGPoint) velocity
{
    _velocity = velocity;
}

- (CGFloat) getDirection
{
    return _direction;
}

- (void) setDirection:(CGFloat) direction
{
    _direction = direction;
}

- (NSArray *) getPath
{
    return _path;
}

- (void) setPath:(NSArray *) path
{
    if(_path != nil)
        [_path release];
    
    _path = [path mutableCopy];
    [_path retain];
}

- (BOOL) isProgress
{
    return _progress;
}

- (void) start
{
    if([self isProgress])
        return;
    
    if([self getPath] == nil || [[self getPath] count] == 0)
    {
        [self onError];
        
        return;
    }
    
    _progress = YES;
    
    [self onStart];
}

- (void) onStart
{
    [[LogUtility getInstance] printMessage:@"onStart"];
}

- (void) resume
{
    if([self isProgress])
        return;
    
    _progress = YES;
    
    [self onResume];
}

- (void) onResume
{
    [[LogUtility getInstance] printMessage:@"onResume"];
}

- (void) stop
{
    if(![self isProgress])
        return;
    
    [self setPath:nil];
    
    _progress = NO;
    
    [self onStop];
}

- (void) onStop
{
    [[LogUtility getInstance] printMessage:@"onStop"];
}

- (void) pause
{
    if(![self isProgress])
        return;
    
    _progress = NO;
    
    [self onPause];
}

- (void) onPause
{
    [[LogUtility getInstance] printMessage:@"onPause"];
}

- (void) onError
{
    [[LogUtility getInstance] printMessage:@"onError"];
}

-(void) draw {
    
    [self onMovement];
    
	if(![self isVisible])
		return;
	
	[super draw];
}

- (void) onMovement 
{
    if(![self isProgress])
        return;
    else if([self getPath] == nil || [[self getPath] count] == 0)
        return;
    
    CGPoint current = [self getCenter];
    CGPoint destination = [(NSValue *) [[self getPath] objectAtIndex:0] CGPointValue];
    
    CGFloat distance = [[MathUtility getInstance] getDistanceBetweenPoints:current :destination];
    
    if(distance <= [self getSpeed])
    {
        [self setCenter:destination];
        
        [[LogUtility getInstance] printFloat:[_path count]];
        
        [(NSMutableArray *) [self getPath] removeObjectAtIndex:0];
        
        if([[self getPath] count] == 0)
        {
            [self setPath:nil];
            
            [self onComplete];
            
            return;
        }
        else
        {
            [self onTurn];
        }
    }
    else
    {
        CGFloat xVelocity = [self getSpeed] * ((destination.x - current.x) / distance);
        CGFloat yVelocity = [self getSpeed] * ((destination.y - current.y) / distance);
        [self setVelocity:CGPointMake(xVelocity, yVelocity)];
        
        CGFloat xDistance = destination.x - current.x;
        CGFloat yDistance = destination.y - current.y;
        
        CGFloat angle = [[MathUtility getInstance] getAngleBetweenHorizontalAxisAndPoint:CGPointMake(xDistance, yDistance)];
        [self setDirection:angle];
        
        [self onProgress];
    }
    
    [self move:[self getVelocity]];
}

- (void) onProgress
{
    [[LogUtility getInstance] printMessage:@"onProgress"];
}

- (void) onTurn
{
    [[LogUtility getInstance] printMessage:@"onTurn"];
}

- (void) onComplete
{
    [[LogUtility getInstance] printMessage:@"onComplete"];
}

-(void) dealloc 
{
    [_path release];
    
	[super dealloc];
}

@end
