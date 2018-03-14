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
#import "DateTimeUtility.h"
#import "LogUtility.h"
#import "PlayWindow.h"

@class Player;

// FIXME: private static should not be in header
// however, removing _zombies from header breaks PlayWindow
static NSMutableArray *_zombies;

@interface Zombie : Skeleton {
    
    BOOL _hit;
    long _hurtMilliseconds;
    NSInteger _hitDistance;
    
    long _collideMilliseconds;
    
    BOOL _appear;
    BOOL _previousAppear;
}

-(id) initWithSize:(CGSize) size;

+(NSMutableArray *) getInstances;
+(void) destroyInstances;

-(void) removeFromInstances;

+(Zombie *) getNearestZombie:(BOOL) fire;

-(BOOL) isAppear;
-(void) setAppear:(BOOL) appear;

-(BOOL) isPreviousAppear;
-(void) setPreviousAppear:(BOOL) appear;

-(void) hurt:(Player *) player;

-(void) hit:(Player *) player;

-(void) artificialIntelligence;

@end
