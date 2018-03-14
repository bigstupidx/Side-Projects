//
//  Zombie.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Coin.h"

static NSMutableArray *_coins;

@implementation Coin

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    [[Coin getInstances] addObject:self];
    
    for(int i = 1; i <= 6; i++)
    {
        NSString *filename = @"Coin";
        filename = [filename stringByAppendingString:@"_"];
        if(i <= 9) filename = [filename stringByAppendingString:@"0"];
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        
        Texture *texture = [[TextureManager getInstance] getTexture:filename];
        FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:i :[texture getSize] :texture] autorelease];
        [self addFrameSet:frameSet];
    }
    
    NSMutableArray *sequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 1; i <= 6; i++) 
        [sequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *frameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:sequence :50] autorelease];
    [self addFrameAnimation:frameAnimation];
    
    _money = 0;
    _milliseconds = -1;
    
    [self setAlpha:0.0];
    
    return self;
}

+(NSMutableArray *) getInstances
{
    if(_coins == nil)
        _coins = [[NSMutableArray alloc] init];
    
    return _coins;
}

+(void) destroyInstances
{
    [_coins removeAllObjects];
    [_coins release];
    _coins = nil;
}

-(void) removeFromInstances
{
    [_coins removeObject:self];
}

-(void) draw
{
    [super draw];
    
    CGFloat alpha = [self getAlpha];
    
    if(_milliseconds < 0)
    {
        if(alpha < 1.0)
        {
            alpha += 2.5;
        }
        else if(alpha >= 1.0) 
        {
            alpha = 1.0;
            _milliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
        }
    }
    else if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _milliseconds >= COIN_TIME)
    {
        if(alpha > 0.0)
        {
            alpha -= 2.5;
        }
        else if(alpha <= 0.0)
        {
            alpha = 0.0;
            [self setVisible:NO];
        }
    }
    
    [self setAlpha:alpha];
    
    if([self isVisible] && [self getAlpha] == 1.0)
    {
        if([self isCollideWith:[Player getInstance]])
        {
            NSInteger money = [[Player getInstance] getMoney];
            money += [self getMoney];
            [[Player getInstance] setMoney:money];
            
            [[SoundManager getInstance] playSound:SOUND_COIN];
            
            [self setVisible:NO];
        }
    }
}

-(NSInteger) getMoney
{
    return _money;
}

-(void) setMoney:(NSInteger) money
{
    _money = money;
}

- (void)dealloc 
{
    [[LogUtility getInstance] printMessage:@"Coin - dealloc"];
    
    [super dealloc];
}

@end
