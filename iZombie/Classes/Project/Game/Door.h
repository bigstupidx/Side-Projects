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

@interface Door : Sprite {
    
    BOOL _use;
    BOOL _prize;
}

-(id) initWithSize:(CGSize) size;

+(NSMutableArray *) getInstances;
+(void) destroyInstances;

-(void) removeFromInstances;

-(BOOL) isUse;
-(void) setUse:(BOOL) use;

@end
