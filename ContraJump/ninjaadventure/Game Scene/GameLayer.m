//
//  GameLayer.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "ZombieGreen.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "AdsManager.h"
#import "Globals.h"
#import "GameoverLayer.h"

@implementation GameLayer



-(id)init {
    if ((self = [super init])) {
        
        [self initMap];
        
        [self scheduleUpdate];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprite.plist"];
        _actors = [CCSpriteBatchNode batchNodeWithFile:@"sprite.pvr.ccz"];
        [_actors.texture setAliasTexParameters];
        [self addChild:_actors z:-5];
        
        
        [self initHero];
        [self initRobots];
        [self initFruits];
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kFPS)];
        
        _bullet = [[NSMutableArray alloc] init];
        
        // Load audio
        if(gGamesMusicStatus==TRUE)
        {
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"HonorLoopable.mp3"];
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"HonorLoopable.mp3"];
        }

        if(gGamesEffectStatus==TRUE)
        {
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_hit0.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_hit1.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_herodeath.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"pd_botdeath.caf"];
        }
       
        [[AdsManager sharedAdsManager] startBannerAd];
        
        //Meng: get system time

        seconds_current = CFAbsoluteTimeGetCurrent() * 1000.0;
        seconds_last=seconds_current;
        seconds_during=0;
        
        map_seconds_current = CFAbsoluteTimeGetCurrent() * 1000.0;
        map_seconds_last=seconds_current;
        map_seconds_during=0;
        
        _hero.shootDirectionForImage = SHOOT_DIRECTION_0_DEGREE;
        _hero.shootDirectionForImage_last = SHOOT_DIRECTION_0_DEGREE;
        _hero.faceDirectionForImage = TRUE;
        
    }
    return self;
}

-(void)initMap {
    mapLayer = [CCLayer node];
    [self addChild:mapLayer z:-6];

    tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level02.tmx"];
    for (CCTMXLayer *child in [tiledMap children]) {
        [[child texture] setAliasTexParameters];
    }
    [mapLayer addChild:tiledMap z:-6];
    
    walls = [tiledMap layerNamed:@"Wall"];
    hazard_points = [tiledMap layerNamed:@"hazard_point"];
    jump_points = [tiledMap layerNamed:@"jump_point"];
    floors = [tiledMap layerNamed:@"Floor"];
    
    roundOfBackground_Current=0;
    createNewMap=TRUE;
    
    
    /*
     NSMutableArray *gids = [NSMutableArray array]; 
    for(int i=0; i<20; i++)
    {
        for(int j=0; j<200; j++)
        {
            CGPoint tilePos = ccp(i, j);
            printf("x:%f  y:%f \r\n",tilePos.x,tilePos.y);
            int tgid = [floors tileGIDAt:tilePos];
            
            
            if(tgid!=0)
            {
                CGRect tileRect = [self tileRectFromTileCoords:tilePos]; //5
                
                NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:tgid], @"gid",
                                          [NSNumber numberWithFloat:tileRect.origin.x], @"x",
                                          [NSNumber numberWithFloat:tileRect.origin.y], @"y",
                                          [NSValue valueWithCGPoint:tilePos],@"tilePos",
                                          nil];
                [gids addObject:tileDict]; //6
            }
            

        }
    }
    
    printf("gids has %d \r\n",gids.count);
    */
    
    

}

-(void)initHero {
    _hero = [Hero node];
    [_actors addChild:_hero];
    _hero.position = ccp(_hero.centerToSides, 400);
    _hero.onFloors = TRUE;
    _hero.onWalls = FALSE;
    _hero.onJumpsPoint = FALSE;
    _hero.onHazardsPoint = FALSE;
    
    _hero.desiredPosition = _hero.position;
    [_hero idle];
    
    heroFarPosition_y = [[CCDirector sharedDirector] winSize].height / 2;
    
    
    realDest = ccp([[CCDirector sharedDirector] winSize].width, _hero.position.y);
    
    // Determine the length of how far we're shooting
    int offRealX = realDest.x - _hero.position.x;
    int offRealY = realDest.y - _hero.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = BULLET_SPEED/1; // pixels/1sec
    realMoveDuration = length/velocity;
}

-(void)initRobots {
    int robotCount = 30;
    self.robots = [[CCArray alloc] initWithCapacity:robotCount];
}

-(void)initFruits {
    int fruitCount = 30;
    self.fruits = [[CCArray alloc] initWithCapacity:fruitCount];
}

//add this method inside the @implementation
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        touchLocation = [self convertTouchToNodeSpace:t];
        //CGPoint previousTouchLocation = [t previousLocationInView:[t view]];
        //CGSize screenSize = [[CCDirector sharedDirector] winSize];
        //previousTouchLocation = ccp(previousTouchLocation.x, screenSize.height - previousTouchLocation.y);
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        touchLocation = [self convertTouchToNodeSpace:t];
        //CGPoint previousTouchLocation = [t previousLocationInView:[t view]];
        //CGSize screenSize = [[CCDirector sharedDirector] winSize];
        //previousTouchLocation = ccp(previousTouchLocation.x, screenSize.height - previousTouchLocation.y);
    }
}

//Meng: When your touch leaves, the move forward action or jump action stops.
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        //CGPoint touchLocation = [self convertTouchToNodeSpace:t];
    }
}

-(void)bulletMoveFinished:(id)sender {
	CCSprite *bullet = (CCSprite *)sender;
	[self removeChild:bullet cleanup:YES];
}

-(void)dealloc {
    [self unscheduleUpdate];
}

-(void)update:(ccTime)dt
{
    [_hero updatePositions_y:dt
                   checkWall:walls
                 checkFloors:floors
                 checkHazard:hazard_points
                   checkJump:jump_points
                       atMap:tiledMap];

    [self updateMapsAndRebots];
    [self updateRobots:dt];
    //[self updateFruit];
    [self reorderActors];
    [self setViewpointCenter:_hero.position];
    
    
    //update time
    seconds_current = CFAbsoluteTimeGetCurrent() * 1000.0;
    seconds_during += seconds_current-seconds_last;
    seconds_last=seconds_current;
    
    //Meng: shooting action
    if(seconds_during>=WEAPON_SHOOT_COOLDOWNTIME_SHOTGUN)
    {
        CCSprite *bullet = [CCSprite spriteWithFile:@"bullet_1.png" rect:CGRectMake(0, 0, 20, 20)];
        bullet.position = ccp(_hero.position.x, _hero.position.y);
        
        [self addChild:bullet];
        
        // Move bullet to actual endpoint
        [bullet runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(bulletMoveFinished:)],
                           nil]];
        
        // Add to projectiles array
        bullet.tag = 2;
        [_bullet addObject:bullet];
        
        seconds_during=0;
    }
    
    map_seconds_current = CFAbsoluteTimeGetCurrent() * 1000.0;

    if(map_seconds_current-map_seconds_last>500)
    {
        map_seconds_during++;
        map_seconds_last=map_seconds_current;
        
        
        CCSprite* background_current = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg_1_%d.png", map_seconds_during%4+1]];
        background_current.anchorPoint = CGPointMake(0, 0);
        background_current.position = ccp(0, roundOfBackground_Current*mapHeightInPixel);
        [mapLayer addChild:background_current z:-100];
        
        CCSprite* background_next = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg_1_%d.png", map_seconds_during%4+1]];
        background_next.anchorPoint = CGPointMake(0, 0);
        background_next.position = ccp(0, (roundOfBackground_Current+1)*mapHeightInPixel);
        [mapLayer addChild:background_next z:-100];
    }
    
    [self shootDirection];
}

//Meng: This method is used to calculate hero's position in x-axis. This method is not used to calculate hero's position in y-axis.
- (void)accelerometer:(UIAccelerometer*)accelerometer
        didAccelerate:(UIAcceleration*)acceleration
{
    [_hero updatePositions_x:acceleration];
}

-(void)updateMapsAndRebots
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //Meng: increase anonther background map 
    if((_hero.position.y >(roundOfBackground_Current*mapHeightInPixel))
       &&(createNewMap==TRUE))
    {
        createNewMap=FALSE;
        
        //create a new map
        tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level02.tmx"];
        for (CCTMXLayer *child in [tiledMap children]) {
            [[child texture] setAliasTexParameters];
        }
        tiledMap.anchorPoint = CGPointMake(0, 0);
        tiledMap.position = ccp(0,(roundOfBackground_Current+1)*mapHeightInPixel);
        [mapLayer addChild:tiledMap z:-6];
        
        //walls = [mapNext layerNamed:@"Wall"];
        //hazard_points = [mapNext layerNamed:@"hazard_point"];
        //jump_points = [mapNext layerNamed:@"jump_point"];
        //floors = [mapNext layerNamed:@"Floor"];

        
        //create rebots for new map.
        //clear robots array before create a new one.
        /*
        int redRobotCount = 16 - 2*roundOfBackground_Current;
        
        //create red robots
        for (int i = 0; i < redRobotCount; i++)
        {
            ZombieGreen *robot = [ZombieGreen node];
            [_actors addChild:robot];
            [_robots addObject:robot];
            
            int minX = SCREEN.width + robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int maxX = mapWidthInPixel - robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int minY = robot.centerToBottom;
            int maxY = mapFloorHeightInPixel + robot.centerToBottom;
            
            robot.scaleX = -1;
            robot.position = ccp(random_range(minX, maxX), random_range(minY, maxY));
            robot.desiredPosition = robot.position;
            //[robot idle];
        }
         */
    }
    
    //Meng: once ninja is in the next map and has already pass winSize.width/2, we can assign createNewMap TRUE for creating the next new map. Why winSize.width/2? Because in that position, ninja cannot walk back to previous map.
    if((_hero.position.y >((roundOfBackground_Current+1)*mapHeightInPixel+winSize.height/2))
       &&(createNewMap==FALSE))
    {
        createNewMap=TRUE;
        roundOfBackground_Current+=1;
    }
}


-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //Meng: in contrajump game, we want to set the view's position.x to the middle of the screen width and view's position.y to (the hero's highest position - win_height/2)
    unsigned int x;
    unsigned int y;
    
    /*
    if(position.y < heroFarPosition_y)
    {
        y = heroFarPosition_y;
    }
    else if(position.y >= heroFarPosition_y)
    {
        y = position.y;
        heroFarPosition_y = position.y;
    }
    */
    
    y = position.y + winSize.height * HERO_VIEWPOINT_PROPORTION;
    x = winSize.width / 2;    

    
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;

}

-(void)reorderActors {
    ActionSprite *sprite;
    CCARRAY_FOREACH(_actors.children, sprite) {
        [_actors reorderChild:sprite z:mapHeightInPixel - sprite.position.y];
    }
}

-(void)updateRobots:(ccTime)dt {
    //int alive = 0;//Meng: the game would never ends because robot will always generate and hero cannot kill all of them.
    ZombieGreen *robot;
    float distance_x; //Meng: the x-distance between hero and robot
    int randomChoice = 0;

    CCARRAY_FOREACH(_robots, robot)
    {
        [robot update:dt];
        if (robot.actionState != kActionStateKnockedOut)
        {
            //alive++;//Meng: the game would never ends because robot will always generate and hero cannot kill all of them.
            
            if (CURTIME > robot.nextDecisionTime)
            {
                if(robot.position.x >= _hero.position.x)
                {
                    distance_x = robot.position.x - _hero.position.x;
                }
                else if(robot.position.x < _hero.position.x)
                {
                    distance_x = _hero.position.x - robot.position.x;                
                }
                
                if (distance_x <= 50)
                {
                    //Meng: if distance_x is smaller than 50, then robot has a chance to hit hero.
                    robot.nextDecisionTime = CURTIME + frandom_range(0.1, 0.5);
                    
                    if([robot isKindOfClass:[ZombieGreen class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=ATTACKCHANCE_RED_NINJA)
                        {
                            randomChoice=0;
                        }
                    }

                    if (randomChoice == 0)
                    {
                        if (_hero.position.x > robot.position.x)
                        {
                            robot.scaleX = 1.0;
                        }
                        else
                        {
                            robot.scaleX = -1.0;
                        }
                        
                        [robot attack];
                        if (robot.actionState == kActionStateAttack)
                        {
                            if (fabsf(_hero.position.y - robot.position.y) < 10)
                            {
                                if (CGRectIntersectsRect(_hero.hitBox.actual, robot.attackBox.actual))
                                {
                                    [_hero hurtWithDamage:robot.damage];
                                    
                                    //Meng added. This global variable is used for updating ninja's health bar.
                                    gNinjaHitPoints_Current = _hero.hitPoints;
                                    
                                    //end game checker here
                                    if (_hero.actionState == kActionStateKnockedOut && [_hud getChildByTag:5] == nil)
                                    {
                                        [self endGame];
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        //[robot idle];
                    }
                }
                else if ((distance_x > 50)
                         &&(distance_x <= SCREEN.width))
                {
                    //Meng: in this case, robot can have a chance to walk to hero.
                    robot.nextDecisionTime = CURTIME + frandom_range(0.5, 1.0);
                    
                    if([robot isKindOfClass:[ZombieGreen class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=WALKCHANCE_RED_NINJA)
                        {
                            randomChoice=0;
                        }
                    }

                    if (randomChoice == 0)
                    {
                        CGPoint moveDirection = ccpNormalize(ccpSub(_hero.position, robot.position));
                        
                        //Meng: I change the walkWithDirection code for contrajump game.
                        BOOL face = TRUE;
                        unsigned int imageNum =1;
                        if(robot.position.x > _hero.position.x)
                        {
                            face = FALSE;
                        }
                        else if(robot.position.x < _hero.position.x)
                        {
                            face = TRUE;
                        }
                        [robot walkWithDirection:moveDirection FaceToLeftOrRight:face WithShootImage:SHOOT_DIRECTION_0_DEGREE];
                    }
                    else
                    {
                        //[robot idle];
                    }
                    
                    if((robot.position.x < _hero.position.x)
                       &&(distance_x > (SCREEN.width/2 + 50)))
                    {
                        //Meng: if robot is behind hero and the distance is bigger than half of the windows size, then remove this robot.
                        [_robots removeObject:robot];
                    }
                }
                else if(distance_x > SCREEN.width)
                {
                    //Meng: in this case, if robot is beyond hero, then they do nothing; if robot is behind hero, then remove this robot.
                    if(robot.position.x > _hero.position.x)
                    {
                        //Meng: nothing happens if robot is beyond hero.
                    }
                    else if(robot.position.x < _hero.position.x)
                    {
                        //Meng: if robot is behind hero, remove this robot.
                        [_robots removeObject:robot];
                    }
                }
            }
        }
        else if (robot.actionState == kActionStateKnockedOut)
        {
            if([robot isKindOfClass:[ZombieGreen class]])
            {
                gGameScore += MONSTER_POINTS_RED_NINJA;
            }

            [self fruitDrop: robot];
            [_robots removeObject:robot];
        }
    }
    
    //end game checker here
    //add this in place of the SECOND placeholder comment
    //Meng: the game would never ends because robot will always generate and hero cannot kill all of them.
    /*
    if (alive == 0 && [_hud getChildByTag:5] == nil) {
        [self endGame];
    }
    */
}

- (void) fruitDrop: (ZombieGreen *)robot
{
    int randomChoice = 0;
    
    if([robot isKindOfClass:[ZombieGreen class]])
    {
        randomChoice = random_range(1, 100);
        if(randomChoice<=FRUIT_DROP_CHANCE_RED_NINJA)
        {
            randomChoice=0;
        }
    }

    if(randomChoice == 0)
    {
        Fruit* newFruit = [Fruit node];
        [newFruit appleDropInX:robot.position.x InY:(robot.position.y - robot.centerToBottom)];
        [self addChild:newFruit z:-6];
        [_fruits addObject:newFruit];
    }
}


-(void)updateFruit
{
    Fruit *fruit;
    CCARRAY_FOREACH(_fruits, fruit)
    {
        if (CGRectIntersectsRect(_hero.hitBox.actual, fruit.hitBox_apple.actual))
        {
                [fruit eaten];
        }
        
        if(fruit.fruitStatus==NO)
        {
            [_fruits removeObject:fruit];
        }
    }
}

-(void)shootDirection
{
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    
    float realX;
    float realY;
    
    //Meng: in this case, player's touch position is above hero's position
    //Meng: I spent hours on calculating the formula below. It needs some trigonometric function knowledges.
    //Meng: square 3 is 1.732 ; square 3 and then devide 3 is 0.577
    if((touchLocation.x>0)
       &&(touchLocation.x<winSize.width*15/100))
    {
        realX = 0;
        realY = _hero.position.y;
        
        _hero.shootDirectionForImage = SHOOT_DIRECTION_0_DEGREE;
        _hero.faceDirectionForImage = FALSE;
    }
    else if((touchLocation.x>=winSize.width*15/100)
            &&(touchLocation.x<winSize.width*35/100))
    {
        realX = 0;
        realY = _hero.position.x + _hero.position.y;
        
        _hero.shootDirectionForImage = SHOOT_DIRECTION_45_DEGREE;
        _hero.faceDirectionForImage = FALSE;
    }
    else if((touchLocation.x>=winSize.width*35/100)
            &&(touchLocation.x<winSize.width*65/100))
    {
        realX = _hero.position.x;
        realY = _hero.position.y + 4 * winSize.height;
        
        _hero.shootDirectionForImage = SHOOT_DIRECTION_90_DEGREE;
        _hero.faceDirectionForImage = FALSE;
        
    }
    else if((touchLocation.x>=winSize.width*65/100)
            &&(touchLocation.x<winSize.width*85/100))
    {
        realX = winSize.width;
        realY = winSize.width - _hero.position.x + _hero.position.y;
        
        _hero.shootDirectionForImage = SHOOT_DIRECTION_45_DEGREE;
        _hero.faceDirectionForImage = TRUE;
    }
    else if((touchLocation.x>=winSize.width*85/100)
            &&(touchLocation.x<winSize.width))
    {
        realX = winSize.width;
        realY = _hero.position.y;
        
        _hero.shootDirectionForImage = SHOOT_DIRECTION_0_DEGREE;
        _hero.faceDirectionForImage = TRUE;
    }
    
    realDest = ccp(realX, realY);
    
    // Determine the length of how far we're shooting
    float offRealX = realDest.x - _hero.position.x;
    float offRealY = realDest.y - _hero.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = BULLET_SPEED/1; // 480pixels/1sec
    realMoveDuration = length/velocity;
}

-(void)endGame {
    CCScene* gameoverScene = [CCScene node];
    GameoverLayer* gameoverLayer = [GameoverLayer node];
    [gameoverLayer setScore:gGameScore];
    [gameoverScene addChild:gameoverLayer z:100];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:0.5
                                        scene:gameoverScene
                                    withColor:ccBLACK]];
    
    
    [[AdsManager sharedAdsManager] showAdOnGameOver];
}

@end
