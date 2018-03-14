//
//  Zombie.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    [[Zombie getInstances] addObject:self];
    
    _hit = NO;
    _hurtMilliseconds = -1;
    _collideMilliseconds = -1;
    _hitDistance = size.width;
    
    NSInteger walkSpeed = [[MathUtility getInstance] getRandomNumber:ZOMBIE_WALK_SPEED_MINIMUM :ZOMBIE_WALK_SPEED_MAXIMUM];
    [self setSpeed:walkSpeed];
    
    [self setAppear:NO];
    [self setAppear:NO];
    
    return self;
}

+(NSMutableArray *) getInstances
{
    if(_zombies == nil)
        _zombies = [[NSMutableArray alloc] init];
    
    return _zombies;
}

+(void) destroyInstances
{
    [_zombies removeAllObjects];
    [_zombies release];
    _zombies = nil;
}

-(void) removeFromInstances
{
    [_zombies removeObject:self];
}

+(Zombie *) getNearestZombie:(BOOL) fire
{
    Zombie *zombie = nil;
    
    NSInteger minimumDistance = NSIntegerMax;
    
    for(int i = 0; i < [[Zombie getInstances] count]; i++)
    {
        Zombie *zombieTemporary = [[Zombie getInstances] objectAtIndex:i];
        
        if([zombieTemporary getLife] <= 0)
            continue;
        
        if([zombieTemporary getDirection] == [[Player getInstance] getDirection])
            continue;
        
        if([[Player getInstance] isCollideWith:zombieTemporary])
            return zombieTemporary;
        
        CGPoint centerZombie = [zombieTemporary getCenter];
        CGSize sizeZombie = [zombieTemporary getSize];
        CGPoint centerPlayer = [[Player getInstance] getCenter];
        
        NSInteger distance = abs(centerZombie.x - centerPlayer.x);
        
        if(fire && distance >= WINDOW_WIDTH / 2)
            continue;
        else if(!fire && distance >= sizeZombie.width)
            continue;
        
        if(distance <= minimumDistance)
        {
            zombie = zombieTemporary;
            minimumDistance = distance;
        }
    }
    
    return zombie;
}

-(BOOL) isAppear
{
    return _appear;
}

-(void) setAppear:(BOOL) appear
{
    [self setPreviousAppear:[self isAppear]];
    
    _appear = appear;
}

-(BOOL) isPreviousAppear
{
    return _previousAppear;
}

-(void) setPreviousAppear:(BOOL) appear
{
    _previousAppear = appear;
}

-(void) hurt:(Player *) player
{
    if([self getLife] <= 0)
        return;
    
    if([player getState] == StateFire)
        [self setLife:[self getLife] - [player getFirePower]];
    else
        [self setLife:[self getLife] - [player getHitPower]];
        
    [self setSpeed:ZOMBIE_HURT_SPEED];
    _hurtMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
    
    [[PlayWindow getInstance] onCreateBlood:self];
    
    [[PlayWindow getInstance] playScream];
}

-(void) hit:(Player *) player
{
    [self hurt:player];
    
    _hit = YES;
    _hitDistance = [self getSize].width / 2;
}

-(void) draw
{
    [super draw];
}

-(void) artificialIntelligence
{   
    Player *player = [Player getInstance];
    
    if(_hit)
    {
        if(_hitDistance > 0)
        {
            if([self getDirection] == DirectionLeft)
            {
                [self move:CGPointMake(ZOMBIE_HIT_DISTANCE_SPEED, 0)];
                _hitDistance -= ZOMBIE_HIT_DISTANCE_SPEED;
            }
            else if([self getDirection] == DirectionRight)
            {
                [self move:CGPointMake(-ZOMBIE_HIT_DISTANCE_SPEED, 0)];
                _hitDistance -= ZOMBIE_HIT_DISTANCE_SPEED;
            }
        }
        else
            _hit = NO;
        
        return;
    }
    
    if(![self isCollideWith:[Player getInstance]])
    {
    
        // Zombie on left.
        if([self getCenter].x - [player getCenter].x < 0)
        {
            [self moveRight];
            NSInteger walkSpeed = [[MathUtility getInstance] getRandomNumber:ZOMBIE_SUPERWALK_SPEED_MINIMUM :ZOMBIE_SUPERWALK_SPEED_MAXIMUM];
            [self setSpeed:walkSpeed];
        }
        // Zombie on right.
        else if([self getCenter].x - [player getCenter].x > 0)
        {
            [self moveLeft];
        }
    }
    
    if([[Player getInstance] getState] == StateDoorEnter || [[Player getInstance] getState] == StateDoorWait || [[Player getInstance] getState] == StateDoorPreExit || [[Player getInstance] getState] == StateDoorExit)
        return;
        
        
    if(_hurtMilliseconds > 0 && [[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _hurtMilliseconds >= ZOMBIE_HURT_TIME)
    {
        NSInteger walkSpeed = [[MathUtility getInstance] getRandomNumber:ZOMBIE_WALK_SPEED_MINIMUM :ZOMBIE_WALK_SPEED_MAXIMUM];
        [self setSpeed:walkSpeed];
        
        _hurtMilliseconds = -1;
    }
    
    if([self isCollideWith:[Player getInstance]])
    {
        if(_collideMilliseconds < 0)
            _collideMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
        
        if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _collideMilliseconds >= ZOMBIE_HIT_TIME)
        {
            [[Player getInstance] hurt:self];
            _collideMilliseconds = -1;
        }
    }
    else
        _collideMilliseconds = -1;
}

- (void)dealloc 
{   
    [[LogUtility getInstance] printMessage:@"Zombie - dealloc"];
    
    [super dealloc];
}

@end
