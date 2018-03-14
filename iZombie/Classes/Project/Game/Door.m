//
//  Zombie.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Door.h"

static NSMutableArray *_doors;

@implementation Door

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    [[Door getInstances] addObject:self];
    
    [self setUse:NO];
    
    _prize = NO;
    
    return self;
}

+(NSMutableArray *) getInstances
{
    if(_doors == nil)
        _doors = [[NSMutableArray alloc] init];
    
    return _doors;
}

+(void) destroyInstances
{
    [_doors removeAllObjects];
    [_doors release];
    _doors = nil;
}

-(void) removeFromInstances
{
    [_doors removeObject:self];
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
    else if(with.y >= center.y + size.height / 2 + DOOR_OFFSET)
        return NO;
    
    return YES;
}

-(BOOL) isUse
{
    return _use;
}

-(void) setUse:(BOOL) use
{
    _use = use;
}

-(void) draw
{
    [super draw];
    
    if([self isUse])
    {
        CGFloat alpha = [self getAlpha];
        alpha -= 0.1;
        if(alpha < 0.0) alpha = 0.0;
        [self setAlpha:alpha];
    }
    
    if([self getAlpha] <= 0.0 && !_prize)
    {
        _prize = YES;
        [[PlayWindow getInstance] onCreatePrize:[self getCenter]];
    }
}

- (void)dealloc 
{
    [[LogUtility getInstance] printMessage:@"Door - dealloc"];
    
    [super dealloc];
}

@end
