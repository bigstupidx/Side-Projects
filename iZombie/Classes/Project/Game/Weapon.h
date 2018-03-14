//
//  Weapon.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "WeaponType.h"

@interface Weapon : Item
{
@private
    NSNumber *_walkFirstIndex;
    NSNumber *_walkCountFrames;
    NSNumber *_idleFirstIndex;
    NSNumber *_idleCountFrames;
    NSNumber *_actionFirstIndex;
    NSNumber *_actionCountFrames;
    NSNumber *_maximumAmmo;
    NSNumber *_power;
    WeaponType _type;
}

-(id)initWithCoder:(NSCoder *) decoder;

-(WeaponType) getType;
-(void) setType:(WeaponType) type;

-(NSInteger) getWalkFirstIndex;
-(void) setWalkFirstIndex:(NSInteger) index;

-(NSInteger) getWalkCountFrames;
-(void) setWalkCountFrames:(NSInteger) count;

-(NSInteger) getIdleFirstIndex;
-(void) setIdleFirstIndex:(NSInteger) index;

-(NSInteger) getIdleCountFrames;
-(void) setIdleCountFrames:(NSInteger) count;

-(NSInteger) getActionFirstIndex;
-(void) setActionFirstIndex:(NSInteger) index;

-(NSInteger) getActionCountFrames;
-(void) setActionCountFrames:(NSInteger) count;

-(NSInteger) getMaximumAmmo;
-(void) setMaximumAmmo:(NSInteger) ammo;

-(NSInteger) getPower;
-(void) setPower:(NSInteger) power;

@end
