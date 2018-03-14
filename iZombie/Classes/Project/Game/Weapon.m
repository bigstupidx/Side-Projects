//
//  Weapon.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon
-(id) init
{
    [super init];
    
    [self setType:WeaponTypeNone];
    [self setWalkFirstIndex:0];
    [self setWalkCountFrames:0];
    [self setIdleFirstIndex:0];
    [self setIdleCountFrames:0];
    [self setActionFirstIndex:0];
    [self setActionCountFrames:0];
    [self setMaximumAmmo:0];
    [self setPower:0];
    
    return self;
}

-(WeaponType) getType
{
    return _type;
}

-(void) setType:(WeaponType) type
{
    _type = type;
}

-(NSInteger) getWalkFirstIndex
{
    return [_walkFirstIndex intValue];
}

-(void) setWalkFirstIndex:(NSInteger) index
{
    _walkFirstIndex = [NSNumber numberWithInt:index];
    [_walkFirstIndex retain];
}

-(NSInteger) getWalkCountFrames
{
    return [_walkCountFrames intValue];
}

-(void) setWalkCountFrames:(NSInteger) count
{
    _walkCountFrames = [NSNumber numberWithInt:count];
    [_walkCountFrames retain];
}

-(NSInteger) getIdleFirstIndex
{
    return [_idleFirstIndex intValue];
}

-(void) setIdleFirstIndex:(NSInteger) index
{
    _idleFirstIndex = [NSNumber numberWithInt:index];
    [_idleFirstIndex retain];
}

-(NSInteger) getIdleCountFrames
{
    return [_idleCountFrames intValue];
}

-(void) setIdleCountFrames:(NSInteger) count
{
    _idleCountFrames = [NSNumber numberWithInt:count];
    [_idleCountFrames retain];
}

-(NSInteger) getActionFirstIndex
{
    return [_actionFirstIndex intValue];
}

-(void) setActionFirstIndex:(NSInteger) index
{
    _actionFirstIndex = [NSNumber numberWithInt:index];
    [_actionFirstIndex retain];
}

-(NSInteger) getActionCountFrames
{
    return [_actionCountFrames intValue];
}

-(void) setActionCountFrames:(NSInteger) count
{
    _actionCountFrames = [NSNumber numberWithInt:count];
    [_actionCountFrames retain];
}

-(NSInteger) getMaximumAmmo
{
    return [_maximumAmmo intValue];
}

-(void) setMaximumAmmo:(NSInteger) ammo
{
    _maximumAmmo = [NSNumber numberWithInt:ammo];
    [_maximumAmmo retain];
}

-(NSInteger) getPower
{
    return [_power intValue];
}

-(void) setPower:(NSInteger) power
{
    _power = [NSNumber numberWithInt:power];
    [_power retain];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	[super initWithCoder:decoder];
	
	if( self != nil )
	{
		//decode properties, other class vars
		_type = [(NSNumber *) [[decoder decodeObjectForKey:@"type"] retain] intValue];
        _walkFirstIndex = [[decoder decodeObjectForKey:@"walkFirstIndex"] retain];
		_walkCountFrames = [[decoder decodeObjectForKey:@"walkCountFrames"] retain];
        _idleFirstIndex = [[decoder decodeObjectForKey:@"idleFirstIndex"] retain];
		_idleCountFrames = [[decoder decodeObjectForKey:@"idleCountFrames"] retain];
        _actionFirstIndex = [[decoder decodeObjectForKey:@"actionFirstIndex"] retain];
		_actionCountFrames = [[decoder decodeObjectForKey:@"actionCountFrames"] retain];
        _maximumAmmo = [[decoder decodeObjectForKey:@"maximumAmmo"] retain];
        _power = [[decoder decodeObjectForKey:@"power"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
	//Encode properties, other class variables, etc
    [encoder encodeObject:[NSNumber numberWithInt:_type] forKey:@"type"];
	[encoder encodeObject:_walkFirstIndex forKey:@"walkFirstIndex"];
	[encoder encodeObject:_walkCountFrames forKey:@"walkCountFrames"];
    [encoder encodeObject:_idleFirstIndex forKey:@"idleFirstIndex"];
	[encoder encodeObject:_idleCountFrames forKey:@"idleCountFrames"];
    [encoder encodeObject:_actionFirstIndex forKey:@"actionFirstIndex"];
	[encoder encodeObject:_actionCountFrames forKey:@"actionCountFrames"];
    [encoder encodeObject:_maximumAmmo forKey:@"maximumAmmo"];
    [encoder encodeObject:_power forKey:@"power"];
}

-(void) dealloc
{
    [_walkFirstIndex release];
    [_walkCountFrames release];
    [_idleFirstIndex release];
    [_idleCountFrames release];
    [_actionFirstIndex release];
    [_actionCountFrames release];
    [_maximumAmmo release];
    [_power release];
    
    [[LogUtility getInstance] printMessage:@"Weapon - dealloc"];
    
    [super dealloc];
}

@end
