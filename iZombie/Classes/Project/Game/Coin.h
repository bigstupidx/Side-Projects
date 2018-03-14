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
#import "Text.h"
#import "Font.h"
#import "Texture.h"
#import "FrameSet.h"
#import "FrameAnimation.h"
#import "LogUtility.h"

@interface Coin : Sprite {
    
    NSInteger _money;
    long _milliseconds;
}

-(id) initWithSize:(CGSize) size;

+(NSMutableArray *) getInstances;
+(void) destroyInstances;
-(void) removeFromInstances;

-(NSInteger) getMoney;
-(void) setMoney:(NSInteger) money;

@end
