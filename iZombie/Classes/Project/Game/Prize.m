//
//  Zombie.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Prize.h"

static NSMutableArray *_prizes;

@implementation Prize

-(id) initWithSize:(CGSize) size :(Text *) text
{
    [super initWithSize:size];
    
    _text = text;
    [_text retain];
    
    [[Prize getInstances] addObject:self];
    
    // Ammo.
    Texture *texture = [[TextureManager getInstance] getTexture:@"Icon_Ammo.png"];
    FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:1 :CGSizeMake(40, 40) :texture] autorelease];
    [self addFrameSet:frameSet];
    NSArray *sequence = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
    FrameAnimation *frameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:sequence :-1] autorelease];
    [self addFrameAnimation:frameAnimation];
    
    NSInteger index = [(NSNumber *) [[Preferences getInstance] getValue:KEY_PLAYER_FIRE] intValue];
    Fire *fire = [[Fire getInstances] objectAtIndex:index];
    
    NSInteger random = [[MathUtility getInstance] getRandomNumber:100];
    if(random <= 65)
        _ammo = [fire getMaximumAmmo] * 0.25;
    else if(random <= 90)
        _ammo = [fire getMaximumAmmo] * 0.50;
    else
        _ammo = [fire getMaximumAmmo];
    
    [[Player getInstance] setAmmo:[[Player getInstance] getAmmo] + _ammo];
    
    // Health.
    random = [[MathUtility getInstance] getRandomNumber:100 :200];
    if(random <= 150)
        _health = 0;
    else if(random <= 175)
        _health = 10;
    else if(random <= 190)
        _health = 25;
    else
        _health = 50;
    
    [[Player getInstance] setLife:[[Player getInstance] getLife] + _health];
    
    if(_health > 0)
    {
        _firstAID = [[[Sprite alloc] initWithSize:CGSizeMake(28, 28)] autorelease];
        texture = [[TextureManager getInstance] getTexture:@"Icon_Health.png"];
        frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:1 :CGSizeMake(28, 28) :texture] autorelease];
        [_firstAID addFrameSet:frameSet];
        sequence = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
        frameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:sequence :-1] autorelease];
        [_firstAID addFrameAnimation:frameAnimation];
        [_firstAID setCenter:CGPointMake(0, [self getSize].height)];
        [self addChild:_firstAID];
    }
    
    _milliseconds = -1;
    
    return self;
}

+(NSMutableArray *) getInstances
{
    if(_prizes == nil)
        _prizes = [[NSMutableArray alloc] init];
    
    return _prizes;
}

+(void) destroyInstances
{
    [_prizes removeAllObjects];
    [_prizes release];
    _prizes = nil;
}

-(void) removeFromInstances
{
    [_prizes removeObject:self];
}

-(void) draw
{
    [super draw];
    
    if(_milliseconds < 0)
    {
        [[SoundManager getInstance] playSound:SOUND_RELOAD];
        _milliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
    }
    
    if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _milliseconds >= DOOR_WAIT_TIME)
    {
        CGFloat alpha = [self getAlpha];
        alpha -= 0.1;
        if(alpha < 0.0) alpha = 0.0;
        
        [self setAlpha:alpha];
        [_firstAID setAlpha:alpha];
    }
    
    Font *font = [_text getFont];
    CGFloat fontSize = [font getSize];
    [font setResize:fontSize * 2 / 4];
    Texture *texture = [font getTexture];
    CGFloat textureAlpha = [texture getAlpha];
    [texture setAlpha:[self getAlpha]];
    
    NSString *ammoString = @"";
    if(_ammo <= 9) ammoString = [ammoString stringByAppendingString:@"0"];
    ammoString = [ammoString stringByAppendingString:[[NSNumber numberWithInteger:_ammo] stringValue]];
    NSInteger xAmmo = [self getCenter].x + ICON_OFFSET / 2;
    NSInteger yAmmo = [self getCenter].y + ICON_OFFSET / 2;
    [_text drawText:ammoString :CGPointMake(xAmmo, yAmmo)];
    
    if(_health > 0)
    {
        NSString *healthString = @"";
        if(_health <= 9) healthString = [healthString stringByAppendingString:@"0"];
        healthString = [healthString stringByAppendingString:[[NSNumber numberWithInteger:_health] stringValue]];
        NSInteger xHealth = [self getCenter].x + ICON_OFFSET;
        NSInteger yHealth = [self getCenter].y + [self getSize].height + ICON_OFFSET;
        [_text drawText:healthString :CGPointMake(xHealth, yHealth)];
    }
    
    [font setResize:fontSize];
    [texture setAlpha:textureAlpha];
    
}

- (void)dealloc 
{
    [_text release];
    
    [[LogUtility getInstance] printMessage:@"Prize - dealloc"];
    
    [super dealloc];
}

@end
