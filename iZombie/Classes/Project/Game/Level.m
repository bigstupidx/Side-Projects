//
//  Level.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Level.h"

static NSMutableArray *_levels = nil;

@implementation Level
-(id) init
{
    [super init];
    
    [[Level getInstances] addObject:self];
    
    [self setMaximumCountZombies:0];
    
    [self setDoorCenter:CGPointMake(0, 0)];
    
    return self;
}

+(NSMutableArray *) getInstances;
{
    if(_levels == nil)
        _levels = [[NSMutableArray alloc] init];
    
    return _levels;
}

+(void) removeAllInstances
{
    [_levels removeAllObjects];
    _levels = nil;
}

-(NSString *) getName
{
    return _name;
}

-(void) setName:(NSString *) name
{
    _name = name;
    [_name retain];
}

-(NSString *) getTMXFilename
{
    return _tmxFilename;
}

-(void) setTMXFilename:(NSString *) filename
{
    _tmxFilename = filename;
    [_tmxFilename retain];
}

-(NSMutableArray *) getZombieFilenames
{
    return _zombieFilenames;
}

-(void) setZombieFilenames:(NSMutableArray *) filenames
{
    _zombieFilenames = filenames;
    [_zombieFilenames retain];
}

-(NSInteger) getMaximumCountZombies
{
    return _maximumCountZombies;
}

-(void) setMaximumCountZombies:(NSInteger) count
{
    _maximumCountZombies = count;
}

-(CGPoint) getDoorCenter
{
    return _doorCenter;
}

-(void) setDoorCenter:(CGPoint) center
{
    _doorCenter = center;
}

-(void) dealloc
{
    [_name release];
    [_tmxFilename release];
    [_zombieFilenames release];
    
    [[LogUtility getInstance] printMessage:@"Level - dealloc"];
    
    [super dealloc];
}

@end
