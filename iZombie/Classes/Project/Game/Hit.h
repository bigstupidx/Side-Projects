//
//  Avatar.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"
#import "Preferences.h"
#import "Constants.h"

@interface Hit : Weapon
{
}

+(NSMutableArray *) getInstances;
+(void) removeAllInstances;
+(void) reset;
+(void) save;

@end
