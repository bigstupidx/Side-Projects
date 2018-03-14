//
//  Avatar.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Hit.h"

static NSMutableArray *_hits = nil;

@implementation Hit
-(id) init
{
    [super init];
    
    [[Hit getInstances] addObject:self];
    
    return self;
}

-(id) initWithCoder:(NSCoder *) decoder
{
    [super initWithCoder:decoder];
    
    [[Hit getInstances] addObject:self];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

+(NSMutableArray *) getInstances
{
    if(_hits == nil)
        _hits = [[NSMutableArray alloc] init];
    
    return _hits;
}

+(void) removeAllInstances
{
    [_hits removeAllObjects];
    _hits = nil;
}

+(void) reset
{
    for(NSInteger i = 0; i < [[Hit getInstances] count]; i++)
    {
        Hit *hit = [[Hit getInstances] objectAtIndex:i];
        [hit setOwn:(i == 0)];
    }
}

+(void) save
{
    [[Preferences getInstance] setValue:_hits :KEY_HITS];
}

-(void) dealloc
{
    [[LogUtility getInstance] printMessage:@"Hit - dealloc"];
    
    [super dealloc];
}

@end
