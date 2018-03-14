//
//  Player.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    _ammo = 0;
    _maximumAmmo = 0;
    _money = 0;
    _doorMilliseconds = -1;
    
    NSNumber *hit = [[Preferences getInstance] getValue:KEY_PLAYER_HIT];
    _hit = [[Hit getInstances] objectAtIndex:[hit intValue]];
    
    NSNumber *fire = [[Preferences getInstance] getValue:KEY_PLAYER_FIRE];
    _fire = [[Fire getInstances] objectAtIndex:[fire intValue]];
        
    NSNumber *avatar = [[Preferences getInstance] getValue:KEY_PLAYER_AVATAR];
    _avatar = [[Avatar getInstances] objectAtIndex:[avatar intValue]];
    
    // Player frame set.
    for(int i = 1; i <= 73; i++)
    {
        NSString *filename = [_avatar getImageFilename];
        filename = [filename stringByAppendingString:@"_"];
        if(i <= 9) filename = [filename stringByAppendingString:@"0"];
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        
        Texture *texture = [[TextureManager getInstance] getTexture:filename];
        FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:i :[texture getSize] :texture] autorelease];
        [self addFrameSet:frameSet];
    }
    
    // Player idle frame animation.
    NSMutableArray *idleSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = [_fire getIdleFirstIndex]; i < [_fire getIdleFirstIndex] + [_fire getIdleCountFrames]; i++) 
        [idleSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *idleFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:idleSequence :50] autorelease];
    [idleFrameAnimation setName:FRAME_ANIMATION_IDLE];
    [self addFrameAnimation:idleFrameAnimation];
    
    // Player walk frame animation.
    NSMutableArray *walkSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = [_fire getWalkFirstIndex]; i < [_fire getWalkFirstIndex] + [_fire getWalkCountFrames]; i++) 
        [walkSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *walkFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:walkSequence :50] autorelease];
    [walkFrameAnimation setName:FRAME_ANIMATION_WALK];
    [self addFrameAnimation:walkFrameAnimation];
    
    
    
    // Player fire frame animation.
    NSMutableArray *fireSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = [_fire getActionFirstIndex]; i < [_fire getActionFirstIndex] + [_fire getActionCountFrames]; i++) 
    {
        [fireSequence addObject:[NSNumber numberWithInt:i]];    
    }
    
    FrameAnimation *fireFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:fireSequence :50] autorelease];
    [fireFrameAnimation setName:FRAME_ANIMATION_FIRE];
    [self addFrameAnimation:fireFrameAnimation];
    
    
    
    // Player hit frame animation.
    NSMutableArray *hitSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = [_hit getActionFirstIndex]; i < [_hit getActionFirstIndex] + [_hit getActionCountFrames]; i++)
    {
        [hitSequence addObject:[NSNumber numberWithInt:i]];      
    }
        
    FrameAnimation *hitFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:hitSequence :50] autorelease];
    [hitFrameAnimation setName:FRAME_ANIMATION_HIT];
    [self addFrameAnimation:hitFrameAnimation];
    
    
    
    [self setMaximumAmmo:[_fire getMaximumAmmo]];
    [self setAmmo:[_fire getMaximumAmmo]];
    [self setFirePower:[_fire getPower]];
    [self setHitPower:[_hit getPower]];
    [self setState:StateIdle];
    [self setSpeed:PLAYER_WALK_SPEED];
    
    // Flame.
    _flame = [[Sprite alloc] initWithSize:CGSizeMake(200, 150)];
    
    // Frame frame set.
    for(int i = 1; i <= 4; i++)
    {
        NSString *filename = [_fire getFlameFilename];
        filename = [filename stringByAppendingString:@"_"];
        if(i <= 9) filename = [filename stringByAppendingString:@"0"];
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        
        Texture *texture = [[TextureManager getInstance] getTexture:filename];
        FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:i :[texture getSize] :texture] autorelease];
        [_flame addFrameSet:frameSet];
    }
    
    // Player fire frame animation.
    NSMutableArray *flameSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 1; i <= 4; i++) 
        [flameSequence addObject:[NSNumber numberWithInt:i]];
    _flameFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:flameSequence :50] autorelease];
    [_flame addFrameAnimation:_flameFrameAnimation];
    [_flame setVisible:NO];
    
    [self addChild:_flame];
    
    return self;
}

+(Player *) getInstance 
{
	if(_player == nil)
		_player = [[Player alloc] initWithSize:CGSizeMake(200, 150)];
	
	return _player;
}

+(void) destroyInstance
{
    [_player release];
    _player = nil;
}

-(NSInteger) getLife
{
    return [super getLife];
}

-(NSInteger) getAmmo
{
    return _ammo;
}

-(void) setAmmo:(NSInteger) ammo
{
    if(ammo > _maximumAmmo)
        ammo = _maximumAmmo;
    
    _ammo = ammo;
}

-(NSInteger) getMaximumAmmo
{
    return _maximumAmmo;
}

-(void) setMaximumAmmo:(NSInteger) ammo
{
    _maximumAmmo = ammo;
}

-(void) moveLeft
{
    if([self getLife] == 0)
        return;
    else if([self getState] == StateHit)
        return;
    
    [super moveLeft];
}

-(void) moveRight
{
    if([self getLife] == 0)
        return;
    else if([self getState] == StateHit)
        return;
    
    [super moveRight]; 
}

-(void) setState:(State) state
{
    [super setState:state];
    
    if([self getState] == StateFire || [self getState] == StateWalkFire)
    {
        [_flame setVisible:YES];
        [_flameFrameAnimation reset];
    }
    else
        [_flame setVisible:NO];
}

-(void) fire 
{
    if([self getAmmo] <= 0)
    {
        [[SoundManager getInstance] playSound:SOUND_EMPTY];
        return;
    }
    else if([self getState] == StateFire || [self getState] == StateHit)
        return;
    else if([self getState] == StateWalkFire && ![_flame isVisible])
        return;
    
    if([self getState] == StateWalk)
        [self setState:StateWalkFire];
    else
        [self setState:StateFire];
    
    [[Player getInstance] setAmmo:[[Player getInstance] getAmmo] - 1];
    
    if([_fire getType] == WeaponTypePistol)
        [[SoundManager getInstance] playSound:SOUND_PISTOL];
    else if([_fire getType] == WeaponTypeShotgun)
        [[SoundManager getInstance] playSound:SOUND_SHOTGUN];
    else if([_fire getType] == WeaponTypeMachinegun)
        [[SoundManager getInstance] playSound:SOUND_SHOTGUN];
    
    Zombie *zombie = [Zombie getNearestZombie:YES];
    if(zombie == nil)
        return;
    
    [zombie hurt:[Player getInstance]];
}

-(void) hit
{
    if([self getState] == StateFire || [self getState] == StateHit)
        return;
    else if([self getState] == StateWalkFire && ![_flame isVisible])
        return;
    
    [self setState:StateHit];
    
    if([_hit getType] == WeaponTypeBaseballBat)
        [[SoundManager getInstance] playSound:SOUND_BASEBALL_BAT];
    else if([_hit getType] == WeaponTypeSword)
        [[SoundManager getInstance] playSound:SOUND_SWORD];
    
    Zombie *zombie = [Zombie getNearestZombie:NO];
    if(zombie == nil)
        return;
    
    [zombie hit:[Player getInstance]];
}

-(void) hurt:(Zombie *) zombie
{
    if([self getLife] <= 0)
        return;
    else if([[PlayWindow getInstance] isExit])
        return;
    
    [self setLife:[self getLife] - [zombie getHitPower]];
    
    [[PlayWindow getInstance] onCreateBlood:self];
    
    [[SoundManager getInstance] playSound:SOUND_HURT];
}

-(BOOL) isCollideDoor:(Door *) door
{
    CGPoint center = [self getCenter];
    CGSize size = [self getSize];
    
    CGPoint doorCenter = [door getCenter];
    CGSize doorSize = [door getSize];
    
    if(center.x - size.width / 4 >= doorCenter.x + doorSize.width / 4)
        return NO;
    else if(center.x + size.width / 4 < doorCenter.x - doorSize.width / 4)
        return NO;
    
    return YES;
}

-(void) artificialIntelligence
{
    if([self getState] == StateHit)
    {
        FrameAnimation *frameAnimation = [self getActiveFrameAnimation];
        if([frameAnimation getFrameIndex] >= [frameAnimation getCountFrameSequence] - 1)
            [self setState:StateIdle];
    }
    else if([self getState] == StateFire || [self getState] == StateWalkFire)
    {
        if([_flameFrameAnimation getFrameIndex] >= [_flameFrameAnimation getCountFrameSequence] - 1)
        {
            if([self getState] == StateWalkFire)
                [self setState:StateWalk];
            else 
                [self setState:StateIdle];
        }
    }
    
    if([self getState] == StateDoorEnter)
    {
        CGFloat alpha = [self getAlpha];
        
        alpha -= 0.1;
        if(alpha < 0.0) alpha = 0.0;
    
        [self setAlpha:alpha];
        
        if(alpha == 0.0)
        {
            [self setState:StateDoorWait];
        }
    }
    else if([self getState] == StateDoorWait)
    {
        if(_doorMilliseconds < 0)
            _doorMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
        
        if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _doorMilliseconds >= DOOR_WAIT_TIME)
        {
            _doorMilliseconds = -1;
            [self setState:StateDoorPreExit];
        }
    }
    else if([self getState] == StateDoorExit)
    {
        CGFloat alpha = [self getAlpha];
        
        alpha += 0.1;
        if(alpha > 1.0) alpha = 1.0;
        
        [self setAlpha:alpha];
        
        if(alpha == 1.0)
        {
            [self setState:StateIdle];
        }
    }
}

-(void) draw
{
    [super draw];
    
    [self artificialIntelligence];
}

-(void) dealloc
{
    [[LogUtility getInstance] printMessage:@"Player - dealloc"];
    
    [super dealloc];
}

@end
