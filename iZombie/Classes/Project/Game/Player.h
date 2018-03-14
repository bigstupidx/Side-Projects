//
//  Player.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "State.h"
#import "Constants.h"
#import "Skeleton.h"
#import "Zombie.h"
#import "Blood.h"
#import "FrameSet.h"
#import "FrameAnimation.h"
#import "Texture.h"
#import "TextureManager.h"
#import "LayerManager.h"
#import "Zombie.h"
#import "PlayWindow.h"
#import "Door.h"
#import "LogUtility.h"
#import "Fire.h"
#import "Hit.h"
#import "Avatar.h"

@class Player;
@class Zombie;
@class Door;

// FIXME: private static should not be in header
// however, removing _player from header breaks PlayWindow
static Player *_player = nil;

@interface Player : Skeleton {
    
    NSInteger _ammo;
    NSInteger _maximumAmmo;
    long _doorMilliseconds;
    
    Hit *_hit;
    Fire *_fire;
    Avatar *_avatar;
    
    Sprite *_flame;
    FrameAnimation *_flameFrameAnimation;
}

-(id) initWithSize:(CGSize) size;

+(Player *) getInstance;
+(void) destroyInstance;

-(NSInteger) getLife;

-(NSInteger) getAmmo;
-(void) setAmmo:(NSInteger) ammo;

-(NSInteger) getMaximumAmmo;
-(void) setMaximumAmmo:(NSInteger) ammo;

-(void) fire;
-(void) hit;
-(void) hurt:(Zombie *) zombie;

-(BOOL) isCollideDoor:(Door *) door;

-(void) artificialIntelligence;

@end
