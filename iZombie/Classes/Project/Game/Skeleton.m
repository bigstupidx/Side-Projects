//
//  Player.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Skeleton.h"

@implementation Skeleton

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    [self setState:StateNone];
    
    [self setLife:100];
    [self setSpeed:1];
    [self setDirection:DirectionRight];
    [self setHitPower:20];
    [self setFirePower:50];
    
    [self setMoney:0];
    [self setPoint:0];
    
    return self;
}

-(State) getState
{
    return _state;
}

-(void) setState:(State) state
{
    if([self getState] == state)
        return;
    
    _state = state;
    
    if(_state == StateIdle)
    {
        NSInteger frameAnimationIndex = [self getFrameAnimationIndexByName:FRAME_ANIMATION_IDLE];
        [self setActiveFrameAnimationIndex:frameAnimationIndex];
    }
    else if(_state == StateWalk)
    {
        NSInteger frameAnimationIndex = [self getFrameAnimationIndexByName:FRAME_ANIMATION_WALK];
        [self setActiveFrameAnimationIndex:frameAnimationIndex];
    }
    else if(_state == StateFire)
    {
        NSInteger frameAnimationIndex = [self getFrameAnimationIndexByName:FRAME_ANIMATION_FIRE];
        [self setActiveFrameAnimationIndex:frameAnimationIndex];
    }
    else if(_state == StateHit)
    {
        NSInteger frameAnimationIndex = [self getFrameAnimationIndexByName:FRAME_ANIMATION_HIT];
        [self setActiveFrameAnimationIndex:frameAnimationIndex];
    }
}

-(NSInteger) getLife
{
    return _life;
}

-(void) setLife:(NSInteger) life
{
    _life = life;
    
    if(_life > 100)
        _life = 100;
    else if(_life < 0)
        _life = 0;
}


-(NSInteger) getMoney
{
    return _money;
}

-(void) setMoney:(NSInteger) money
{
    _money = money;
}

-(NSInteger) getSpeed
{
    return _speed;
}

-(void) setSpeed:(NSInteger) speed
{
    [self setPreviousSpeed:[self getSpeed]];
    
    _speed = speed;
}

-(NSInteger) getPreviousSpeed
{
    return _previousSpeed;
}

-(void) setPreviousSpeed:(NSInteger) speed
{
    _previousSpeed = speed;
}

-(Direction) getDirection
{
    return _direction;
}

-(void) setDirection:(Direction) direction
{
    _direction = direction;
}

-(NSInteger) getHitPower
{
    return _hitPower;
}

-(void) setHitPower:(NSInteger) power
{
    _hitPower = power;
}

-(NSInteger) getFirePower
{
    return _firePower;
}

-(void) setFirePower:(NSInteger) power
{
    _firePower = power;
}

-(NSInteger) getPoint
{
    return _point;
}

-(void) setPoint:(NSInteger) point
{
    _point = point;
}

-(void) moveLeft
{
    if([self getState] != StateWalk && [self getState] != StateWalkFire)
        [self setState:StateWalk];
    
    [self setFlip:FlipHorizontal];
    [self move:CGPointMake(-[self getSpeed], 0)];
    [self setDirection:DirectionLeft];
}

-(void) moveRight
{
    if([self getState] != StateWalk && [self getState] != StateWalkFire)
        [self setState:StateWalk];
    
    [self setFlip:FlipNone];
    [self move:CGPointMake([self getSpeed], 0)];
    [self setDirection:DirectionRight];
}

-(void) draw
{
    [super draw];
}

-(void) dealloc
{
    [[LogUtility getInstance] printMessage:@"Skeleton - dealloc"];
    
    [super dealloc];
}

@end
