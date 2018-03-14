//
//  Avatar.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Preferences.h"
#import "Constants.h"

@interface Avatar : Item
{
    CGPoint _pistolFlameCenter;
    CGPoint _shotgunFlameCenter;
    CGPoint _machinegunFlameCenter;
}

+(NSMutableArray *) getInstances;
+(void) removeAllInstances;
+(void) reset;
+(void) save;

-(CGPoint) getPistolFlameCenter;
-(void) setPistolFlameCenter:(CGPoint) center;

-(CGPoint) getShotgunFlameCenter;
-(void) setShotgunFlameCenter:(CGPoint) center;

-(CGPoint) getMachinegunFlameCenter;
-(void) setMachinegunFlameCenter:(CGPoint) center;

@end
