//
//  Zombie.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Death.h"

static NSMutableArray *_deaths;

@implementation Death

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    [[Death getInstances] addObject:self];
    
    return self;
}

+(NSMutableArray *) getInstances
{
    if(_deaths == nil)
        _deaths = [[NSMutableArray alloc] init];
    
    return _deaths;
}

+(void) destroyInstances
{
    [_deaths removeAllObjects];
    [_deaths release];
    _deaths = nil;
}

-(void) removeFromInstances
{
    [_deaths removeObject:self];
}

-(void) draw
{
    [super draw];
}

- (void)dealloc 
{
    [[LogUtility getInstance] printMessage:@"Death - dealloc"];
    
    [super dealloc];
}

@end
