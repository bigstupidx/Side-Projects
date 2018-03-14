//
//  ActionSprite.h
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-11.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ActionSprite : CCSprite {
}

//actions
@property(nonatomic,strong)id idleAction_0_degree;
@property(nonatomic,strong)id idleAction_45_degree;
@property(nonatomic,strong)id idleAction_90_degree;

@property(nonatomic,strong)id attackAction;
@property(nonatomic,strong)id walkAction_0_degree_shoot;
@property(nonatomic,strong)id walkAction_45_degree_shoot;
@property(nonatomic,strong)id walkAction_90_degree_shoot;
@property(nonatomic,strong)id hurtAction;
@property(nonatomic,strong)id knockedOutAction;

//states
@property(nonatomic,assign)ActionState actionState;


//attributes
@property(nonatomic,assign)float walkSpeed;
@property(nonatomic,assign)float hitPoints;
@property(nonatomic,assign)float damage;

//movement
@property(nonatomic,assign)CGPoint velocity;
@property(nonatomic,assign)CGPoint desiredPosition;

@property(nonatomic,assign)BOOL onFloors;
@property(nonatomic,assign)BOOL onWalls;
@property(nonatomic,assign)BOOL onJumpsPoint;
@property(nonatomic,assign)BOOL onHazardsPoint;

//shoot
@property(nonatomic,assign)unsigned int shootDirectionForImage; //Meng added
@property(nonatomic,assign)unsigned int shootDirectionForImage_last; //Meng added
@property(nonatomic,assign)BOOL faceDirectionForImage; //Meng: true: shoot left; true: shoot right

//measurements
@property(nonatomic,assign)float centerToSides;
@property(nonatomic,assign)float centerToBottom;

//bounding box
@property(nonatomic,assign)BoundingBox hitBox;
@property(nonatomic,assign)BoundingBox attackBox;

//action methods
-(void)idle;
-(void)attack;
-(void)hurtWithDamage:(float)damage;
-(void)knockout;
-(void)walkWithDirection:(CGPoint)direction FaceToLeftOrRight:(BOOL)faceToLeft WithShootImage:(unsigned int)shootImage;

//scheduled methods
-(void)update:(ccTime)dt;
-(CGRect)collisionBoundingBox;
-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size;

//character positon update methods
-(void)updatePositions_x:(UIAcceleration*)acceleration;

-(void)updatePositions_y:(ccTime)dt
               checkWall:(CCTMXLayer *)walls
             checkFloors:(CCTMXLayer *)floors
             checkHazard:(CCTMXLayer *)hazard_points
               checkJump:(CCTMXLayer *)jump_points
                   atMap:(CCTMXTiledMap *)map;
-(void)collisionCheck:(CCTMXLayer *)layer forType:(int)tileType;

@end
