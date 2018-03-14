//
//  ActionSprite.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-11.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ActionSprite.h"
#import "SimpleAudioEngine.h"
#import "Globals.h"
#import "GameLayer.h"

@implementation ActionSprite

@synthesize onFloors = _onFloors;
@synthesize onWalls = _onWalls;
@synthesize onJumpsPoint = _onJumpsPoint;
@synthesize onHazardsPoint = _onHazardsPoint;

-(void)idle
{
    if (_actionState != kActionStateIdle) {
        [self stopAllActions];
        
        if(self.shootDirectionForImage_last==SHOOT_DIRECTION_0_DEGREE)
        {
            [self runAction:_idleAction_0_degree];
        }
        else if(self.shootDirectionForImage_last==SHOOT_DIRECTION_45_DEGREE)
        {
            [self runAction:_idleAction_45_degree];
        }
        else if(self.shootDirectionForImage_last==SHOOT_DIRECTION_90_DEGREE)
        {
            [self runAction:_idleAction_90_degree];
        }
        
        _actionState = kActionStateIdle;
        _velocity = CGPointZero;
    }
}

-(void)attack {
    if (_actionState == kActionStateIdle || _actionState == kActionStateAttack || _actionState == kActionStateWalk) {
        [self stopAllActions];
        [self runAction:_attackAction];
        _actionState = kActionStateAttack;
    }
}


-(void)walkWithDirection:(CGPoint)direction FaceToLeftOrRight:(BOOL)faceToLeft WithShootImage:(unsigned int)shootImage
{
  
    if ((_actionState == kActionStateIdle)||(self.shootDirectionForImage_last!=shootImage)) {
        [self stopAllActions];
        
        if(shootImage==SHOOT_DIRECTION_0_DEGREE)
        {
            [self runAction:_walkAction_0_degree_shoot];
        }
        else if(shootImage==SHOOT_DIRECTION_45_DEGREE)
        {
            [self runAction:_walkAction_45_degree_shoot];
        }
        else if(shootImage==SHOOT_DIRECTION_90_DEGREE)
        {
            [self runAction:_walkAction_90_degree_shoot];
        }
        _actionState = kActionStateWalk;
        self.shootDirectionForImage_last=shootImage;
    }
     
    
    if (_actionState == kActionStateWalk) {
        if(faceToLeft == TRUE)
        {
            self.scaleX = 1.0;
        }
        else if(faceToLeft == FALSE)
        {
            self.scaleX = -1.0;
        }
            
    }
}

-(void)update:(ccTime)dt {

}

-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size {
    BoundingBox boundingBox;
    boundingBox.original.origin = origin;
    boundingBox.original.size = size;
    boundingBox.actual.origin = ccpAdd(position_, ccp(boundingBox.original.origin.x, boundingBox.original.origin.y));
    boundingBox.actual.size = size;
    return boundingBox;
}



-(void)transformBoxes {
    _hitBox.actual.origin = ccpAdd(position_, ccp(_hitBox.original.origin.x * scaleX_, _hitBox.original.origin.y * scaleY_));
    _hitBox.actual.size = CGSizeMake(_hitBox.original.size.width * scaleX_, _hitBox.original.size.height * scaleY_);
    _attackBox.actual.origin = ccpAdd(position_, ccp(_attackBox.original.origin.x * scaleX_, _attackBox.original.origin.y * scaleY_));
    _attackBox.actual.size = CGSizeMake(_attackBox.original.size.width * scaleX_, _attackBox.original.size.height * scaleY_);
}

-(void)setPosition:(CGPoint)position {
    [super setPosition:position];
    [self transformBoxes];
}

-(void)hurtWithDamage:(float)damage {
    if (_actionState != kActionStateKnockedOut) {
        [self stopAllActions];
        [self runAction:_hurtAction];
        _actionState = kActionStateHurt;
        _hitPoints -= damage;
        
        int randomSound = random_range(0, 1);
        [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"pd_hit%d.caf", randomSound]];
        
        if (_hitPoints <= 0.0) {
            [self knockout];
        }
    }
}

-(void)knockout {
    [self stopAllActions];
    [self runAction:_knockedOutAction];
    _hitPoints = 0.0;
    _actionState = kActionStateKnockedOut;
}

-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}

-(void)updatePositions_x:(UIAcceleration*)acceleration
{
    acceleration_x = acceleration.x;
    acceleration_y = acceleration.y;
    
    float speedX = self.velocity.x;
    float speedY = self.velocity.y;
    
    if(acceleration_x >= ACCELERATION_BALANCE)
    {
        speedX = self.walkSpeed;
        [self walkWithDirection:ccp(speedX,speedY) FaceToLeftOrRight:self.faceDirectionForImage WithShootImage:self.shootDirectionForImage];
        self.velocity = ccp(speedX,speedY);
    }
    else if((acceleration_x < ACCELERATION_BALANCE)&&(acceleration_x > -ACCELERATION_BALANCE))
    {
        [self idle];
        self.velocity = ccp(0,speedY);
    }
    else if(acceleration_x <= -ACCELERATION_BALANCE)
    {
        speedX = -self.walkSpeed;
        [self walkWithDirection:ccp(speedX,speedY) FaceToLeftOrRight:self.faceDirectionForImage WithShootImage:self.shootDirectionForImage];
        self.velocity = ccp(speedX,speedY);
    }
}

//Meng: This method is used to calculate hero's position in y-axis. And update hero's position in both x-axis and y-axis.
-(void)updatePositions_y:(ccTime)dt
               checkWall:(CCTMXLayer *)walls
             checkFloors:(CCTMXLayer *)floors
             checkHazard:(CCTMXLayer *)hazard_points
               checkJump:(CCTMXLayer *)jump_points
                   atMap:(CCTMXTiledMap *)map
{
    float speedX = self.velocity.x;
    float speedY = self.velocity.y;
    
    //Meng: gravity is actually the acceleration speed from the earth.
    CGFloat gravity = GRAVITY_FORCE_HERO;
    CGFloat gravityStep=0;
    
    //Meng: acceleration speed mutiply time is the speed, so gravityStep is the increased speed in the down direction during the time.
    gravityStep = gravity * dt;
    
    //Meng: velocity is the actual speed.
    speedY = self.velocity.y + gravityStep;
    
    [self collisionCheck:floors  forType:tileType_floors atMap:map];
    if(self.onFloors==TRUE)
    {
        speedY = 0;
    }
    
    //Meng: jumpForce indicates the jump speed when hero starts to jump, which also decide how height can hero reach.
    CGFloat jumpForce = JUMP_FORCE_HERO;
    [self collisionCheck:jump_points  forType:tileType_jumps atMap:map];
    if (self.onJumpsPoint)
    {
        //Meng: self.onJumpsPoint is True means you finger touches the right part of the screen; self.onFloors is True means colar is still standing on the ground; so, colar does a jump. It could be a full jump or a short jump, and it deponds on if we can go into the "else if" code. But not matter a full jump or short jump, we must go into this "if" code for sure once we click the right part of screen and colar is on the ground at the same time.
        speedY = jumpForce;
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
    }
    
    
    //Meng: If falling speed is too fast, it may skip the frame check for stand on the floor or not. So, we set its speed limite to avoid this problem.    
    if(speedY<-JUMP_SPEED_LIMIT)
    {
        speedY=-JUMP_SPEED_LIMIT;
    }

    if(speedY>JUMP_SPEED_LIMIT)
    {
        speedY=JUMP_SPEED_LIMIT;
    }
    
    self.velocity = ccp(speedX,speedY);
    

    
    //Meng: speed mutiply time is the distance, so stepVelocity is the increased distance in the time.
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    //Meng: self.postion is the current position and stepVelocity is the increased distance in the time, so desiredPosition is the position which player desires to go.
    self.position = ccpAdd(self.position, stepVelocity);
    
    //Meng: In contrajump game, the interval of hero walking region is from 0 to the screen's width.
    float positionX = self.position.x;
    float positionY = self.position.y;
    if(positionX<self.centerToSides)
    {
        positionX = self.centerToSides;
    }
    else if(positionX>(mapWidthInPixel-self.centerToSides))
    {
        positionX = mapWidthInPixel-self.centerToSides;
    }
    self.position = ccp(positionX, positionY);
    
}

-(void)collisionCheck:(CCTMXLayer *)layer forType:(int)tileType atMap:(CCTMXTiledMap *)map
{
    //Left Rectangle Center
    CGPoint tilePos_LeftRectangleCenter = ccp(self.position.x-self.centerToSides,
                                              self.position.y);
    
    //Right Rectangle Center
    CGPoint tilePos_RightRectangleCenter = ccp(self.position.x+self.centerToSides,
                                               self.position.y);
    
    //Up Rectangle Center
    CGPoint tilePos_UpRectangleCenter = ccp(self.position.x,
                                            self.position.y+self.centerToBottom);
    
    //Down Rectangle Center
    CGPoint tilePos_DownRectangleCenter = ccp(self.position.x,
                                              self.position.y-self.centerToBottom);
    
    int tgid;
    CGPoint plPos;
    
    //left point
    plPos = [self tileCoordForPosition:tilePos_LeftRectangleCenter atMap:map];
    
    if( plPos.x>=tileWidthMinIndex && plPos.x<=tileWidthMaxIndex
       && plPos.y>tileHeightMinIndex && plPos.y<=tileHeightMaxIndex)
    {
        tgid = [layer tileGIDAt:plPos];
        
        if(tgid!=0)
        {
            switch (tileType) {
                case tileType_walls:
                    
                    break;
                case tileType_floors:
                    
                    break;
                case tileType_jumps:
                    
                    break;
                case tileType_hazards:
                    
                    break;
                default:
                    break;
            }
        }
    }
    
    //right point
    plPos = [self tileCoordForPosition:tilePos_RightRectangleCenter atMap:map];
    
    if( plPos.x>=tileWidthMinIndex && plPos.x<=tileWidthMaxIndex
       && plPos.y>tileHeightMinIndex && plPos.y<=tileHeightMaxIndex)
    {
        tgid = [layer tileGIDAt:plPos];
        
        if(tgid!=0)
        {
            switch (tileType) {
                case tileType_walls:
                    
                    break;
                case tileType_floors:
                    
                    break;
                case tileType_jumps:
                    
                    break;
                case tileType_hazards:
                    
                    break;
                default:
                    break;
            }
        }
    }
    
    //Head point
    plPos = [self tileCoordForPosition:tilePos_UpRectangleCenter atMap:map];
    
    if( plPos.x>=tileWidthMinIndex && plPos.x<=tileWidthMaxIndex
       && plPos.y>tileHeightMinIndex && plPos.y<=tileHeightMaxIndex)
    {
        tgid = [layer tileGIDAt:plPos];
        
        if(tgid!=0)
        {
            switch (tileType) {
                case tileType_walls:
                    
                    break;
                case tileType_floors:
                    
                    break;
                case tileType_jumps:
                    
                    break;
                case tileType_hazards:
                    
                    break;
                default:
                    break;
            }
        }
    }
    
    
    //Feet point
    //Meng: When I test my game, I found that sometimes if hero jumps from a high place, because of his fast speed, it may skip a frame of position check. Thus, I want to give more check points for the feet.
    
    for(int i=0; i<100;i++)
    {
        plPos = [self tileCoordForPosition:ccp(tilePos_DownRectangleCenter.x, tilePos_DownRectangleCenter.y-32-i/10) atMap:map];
        
        while(plPos.y<tileHeightMinIndex)
        {
            plPos.y += tileHeightMaxIndex+1;
        }
        
        if( plPos.x>=tileWidthMinIndex && plPos.x<=tileWidthMaxIndex
           && plPos.y>tileHeightMinIndex && plPos.y<=tileHeightMaxIndex)
        {
            
            //Meng: Hero is in jumping
            tgid = [layer tileGIDAt:plPos];
            if(tgid!=0)
            {
                self.onJumpsPoint = FALSE;
                
                switch (tileType) {
                    case tileType_walls:
                        //Meng: hero's feet is on wall
                        self.onFloors = FALSE;
                        self.onWalls = TRUE;
                        self.onJumpsPoint = FALSE;
                        self.onHazardsPoint = FALSE;
                        break;
                    case tileType_floors:
                        //Meng: hero's feet is on ground
                        self.onFloors = TRUE;
                        self.onWalls = FALSE;
                        self.onJumpsPoint = FALSE;
                        self.onHazardsPoint = FALSE;
                        return;
                        break;
                    case tileType_jumps:
                        //Meng: hero's feet is on jump point
                        self.onFloors = FALSE;
                        self.onWalls = FALSE;
                        self.onJumpsPoint = TRUE;
                        self.onHazardsPoint = FALSE;
                        return;
                        break;
                    case tileType_hazards:
                        //Meng: hero's feet is on hazard point
                        self.onFloors = FALSE;
                        self.onWalls = FALSE;
                        self.onJumpsPoint = FALSE;
                        self.onHazardsPoint = TRUE;
                        break;
                    default:
                        break;
                }
            }
            else if(tgid==0)
            {
                self.onFloors = FALSE;
                self.onWalls = FALSE;
                self.onJumpsPoint = FALSE;
                self.onHazardsPoint = TRUE;
            }
        }
    }
    

}


//Meng: this method is used to calculate the tile coordinate from its pixel coordinate
- (CGPoint)tileCoordForPosition:(CGPoint)position atMap:(CCTMXTiledMap *)map
{
    float x = floor(position.x / map.tileSize.width);
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    float y = floor((levelHeightInPixels - position.y) / map.tileSize.height);

    return ccp(x, y);
}


@end
