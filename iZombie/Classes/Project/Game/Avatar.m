//
//  Avatar.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Avatar.h"

static NSMutableArray *_avatars = nil;

@implementation Avatar
-(id) init
{
    [super init];
    
    [[Avatar getInstances] addObject:self];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    [super initWithCoder:decoder];
    
    [[Avatar getInstances] addObject:self];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

+(NSArray *) getInstances
{
    if(_avatars == nil)
        _avatars = [[NSMutableArray alloc] init];
    
    return _avatars;
}

+(void) removeAllInstances
{
    [_avatars removeAllObjects];
    _avatars = nil;
}

+(void) reset
{
    for(NSInteger i = 0; i < [[Avatar getInstances] count]; i++)
    {
        Avatar *avatar = [[Avatar getInstances] objectAtIndex:i];
        [avatar setOwn:(i == 0)];
    }
}

+(void) save
{
    [[Preferences getInstance] setValue:_avatars :KEY_AVATARS];
}

-(CGPoint) getPistolFlameCenter
{
    return _pistolFlameCenter;
}

-(void) setPistolFlameCenter:(CGPoint) center
{
    _pistolFlameCenter = center;
}

-(CGPoint) getShotgunFlameCenter
{
    return _shotgunFlameCenter;
}

-(void) setShotgunFlameCenter:(CGPoint) center
{
    _shotgunFlameCenter = center;
}

-(CGPoint) getMachinegunFlameCenter
{
    return _machinegunFlameCenter;
}

-(void) setMachinegunFlameCenter:(CGPoint) center
{
    _machinegunFlameCenter = center;
}

-(void) dealloc
{
    [[LogUtility getInstance] printMessage:@"Avatar - dealloc"];
    
    [super dealloc];
}

@end
