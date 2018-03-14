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
#import "Direction.h"
#import "LogUtility.h"

@interface Skeleton : Sprite {
    
    State _state;
    NSInteger _life;
    NSInteger _money;
    NSInteger _speed;
    NSInteger _previousSpeed;
    Direction _direction;
    NSInteger _hitPower;
    NSInteger _firePower;
    NSInteger _point;
}

-(id) initWithSize:(CGSize) size;

-(State) getState;
-(void) setState:(State) state;

-(NSInteger) getLife;
-(void) setLife:(NSInteger) life;

-(NSInteger) getMoney;
-(void) setMoney:(NSInteger) money;

-(NSInteger) getSpeed;
-(void) setSpeed:(NSInteger) speed;

-(NSInteger) getPreviousSpeed;
-(void) setPreviousSpeed:(NSInteger) speed;

-(Direction) getDirection;
-(void) setDirection:(Direction) direction;

-(NSInteger) getHitPower;
-(void) setHitPower:(NSInteger) power;

-(NSInteger) getFirePower;
-(void) setFirePower:(NSInteger) power;

-(NSInteger) getPoint;
-(void) setPoint:(NSInteger) point;

-(void) moveLeft;
-(void) moveRight;

@end
