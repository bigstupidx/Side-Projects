//
//  Zombie.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "State.h"
#import "Constants.h"
#import "Skeleton.h"
#import "Player.h"
#import "LogUtility.h"

@interface Blood : Sprite {
    
}

-(id) initWithSize:(CGSize) size;

+(NSMutableArray *) getInstances;
+(void) destroyInstances;

-(void) removeFromInstances;

@end
