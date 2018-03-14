//
//  Zombie.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Blood.h"

static NSMutableArray *_bloods;

@implementation Blood

-(id) initWithSize:(CGSize) size
{
    [super initWithSize:size];
    
    [[Blood getInstances] addObject:self];
    
    return self;
}

+(NSMutableArray *) getInstances
{
    if(_bloods == nil)
        _bloods = [[NSMutableArray alloc] init];
    
    return _bloods;
}

+(void) destroyInstances
{
    [_bloods removeAllObjects];
    [_bloods release];
    _bloods = nil;
}

-(void) removeFromInstances
{
    [_bloods removeObject:self];
}

-(void) draw
{
    [super draw];
}

- (void)dealloc 
{
    [[LogUtility getInstance] printMessage:@"Blood - dealloc"];
    
    [super dealloc];
}

@end
