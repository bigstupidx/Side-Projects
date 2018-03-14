//
//  GameLayer.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "RedRobot.h"
#import "YellowRobot.h"
#import "BlueRobot.h"
#import "PurpleRobot.h"
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
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninjaSprite.plist"];
        _actors = [CCSpriteBatchNode batchNodeWithFile:@"ninjaSprite.pvr.ccz"];
        [_actors.texture setAliasTexParameters];
        [self addChild:_actors z:-5];
        
        [self initHero];
        [self initRobots];
        [self initFruits];
        self.isTouchEnabled = YES;
        
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
    }
    return self;
}

-(void)initMap {
    mapLayer = [CCLayer node];
    [self addChild:mapLayer z:-6];
    
    CCSprite* background = [CCSprite spriteWithFile:@"bg_1_1_a.png"];
    background.anchorPoint = CGPointMake(0, 0);
    background.position = ccp(0, 0);
    
    [mapLayer addChild:background z:-1];
    
    roundOfBackground_Current=0;
    createNewMap=TRUE;
}

-(void)initHero {
    _hero = [Hero node];
    [_actors addChild:_hero];
    _hero.position = ccp(_hero.centerToSides, 80);
    _hero.desiredPosition = _hero.position;
    [_hero idle];
    
    heroFarPosition_x = [[CCDirector sharedDirector] winSize].width / 2;
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
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_hero attack];
    
    if (_hero.actionState == kActionStateAttack) {
        RedRobot *robot;
        CCARRAY_FOREACH(_robots, robot) {
            if (robot.actionState != kActionStateKnockedOut) {
                if (fabsf(_hero.position.y - robot.position.y) < 10) {
                    if (CGRectIntersectsRect(_hero.attackBox.actual, robot.hitBox.actual)) {
                        [robot hurtWithDamage:_hero.damage];
                    }
                }
            }
        }
    }
}



-(void)simpleDPad:(SimpleDPad *)simpleDPad didChangeDirectionTo:(CGPoint)direction {
    [_hero walkWithDirection:direction];
}

-(void)simpleDPadTouchEnded:(SimpleDPad *)simpleDPad {
    if (_hero.actionState == kActionStateWalk) {
        [_hero idle];
    }
}

-(void)simpleDPad:(SimpleDPad *)simpleDPad isHoldingDirection:(CGPoint)direction {
    [_hero walkWithDirection:direction];
}

-(void)dealloc {
    [self unscheduleUpdate];
}

-(void)update:(ccTime)dt {
    [_hero update:dt];
    [self updatePositions];
    [self updateMapsAndRebots];
    [self updateRobots:dt];
    [self updateFruit];
    [self reorderActors];
    [self setViewpointCenter:_hero.position];
}

-(void)updatePositions
{
    //Update hero's position
    //float posX = MIN(mapWidthInPixel - _hero.centerToSides, MAX(_hero.centerToSides, _hero.desiredPosition.x));
    //float posY = MIN(mapFloorHeightInPixel + _hero.centerToBottom, MAX(_hero.centerToBottom, _hero.desiredPosition.y));
    float posX=0;
    if(_hero.desiredPosition.x>=(_hero.centerToSides+heroFarPosition_x-[[CCDirector sharedDirector] winSize].width / 2))
    {
        posX=_hero.desiredPosition.x;
    }
    else if(_hero.desiredPosition.x<(_hero.centerToSides+heroFarPosition_x-[[CCDirector sharedDirector] winSize].width / 2))
    {
        posX=_hero.centerToSides+heroFarPosition_x-[[CCDirector sharedDirector] winSize].width / 2;
    }
    
    float posY=0;
    if((_hero.desiredPosition.y>=_hero.centerToBottom)&&(_hero.desiredPosition.y<mapFloorHeightInPixel))
    {
        posY=_hero.desiredPosition.y;
    }
    else if(_hero.desiredPosition.y<_hero.centerToBottom)
    {
        posY=_hero.centerToBottom;
    }
    else if(_hero.desiredPosition.y>=mapFloorHeightInPixel)
    {
        posY=mapFloorHeightInPixel;
    }
    
    
    _hero.position = ccp(posX, posY);
    
    if(posX>heroFarPosition_x)
    {
        heroFarPosition_x = posX;
    }
    
    //Update robots's position
    RedRobot *robot;
    CCARRAY_FOREACH(_robots, robot)
    {
        //posX = MIN(mapWidthInPixel - robot.centerToSides, MAX(robot.centerToSides, robot.desiredPosition.x));
        //posY = MIN(mapFloorHeightInPixel + robot.centerToBottom, MAX(robot.centerToBottom, robot.desiredPosition.y));
        
        /*
        if(robot.desiredPosition.x>=(robot.centerToSides+roundOfBackground_Current*mapWidthInPixel))
        {
            posX=robot.desiredPosition.x;
        }
        else if(robot.desiredPosition.x<(robot.centerToSides+roundOfBackground_Current*mapWidthInPixel))
        {
            posX=robot.centerToSides+roundOfBackground_Current*mapWidthInPixel;
        }
        */
   
        posX=robot.desiredPosition.x;
        
        if((robot.desiredPosition.y>=robot.centerToBottom)&&(robot.desiredPosition.y<mapFloorHeightInPixel))
        {
            posY=robot.desiredPosition.y;
        }
        else if(robot.desiredPosition.y<robot.centerToBottom)
        {
            posY=robot.centerToBottom;
        }
        else if(robot.desiredPosition.y>=mapFloorHeightInPixel)
        {
            posY=mapFloorHeightInPixel;
        }
        
        robot.position = ccp(posX, posY);
    }
}

-(void)updateMapsAndRebots
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //Meng: increase anonther background map 
    if((_hero.position.x >(roundOfBackground_Current*mapWidthInPixel))
       &&(createNewMap==TRUE))
    {
        createNewMap=FALSE;
        
        //create a new map
        CCSprite* background = [CCSprite spriteWithFile:@"bg_1_1_a.png"];
        background.anchorPoint = CGPointMake(0, 0);
        background.position = ccp((roundOfBackground_Current+1)*mapWidthInPixel, 0);
        
        [mapLayer addChild:background z:-1];
        
        //create rebots for new map.
        //clear robots array before create a new one.
        
        int redRobotCount = 16 - 2*roundOfBackground_Current;
        int yellowRobotCount = 10 - roundOfBackground_Current;
        int blueRobotCount = 4 + 2*roundOfBackground_Current;
        int purpleRobotCount = 0 + roundOfBackground_Current;
        
        //create red robots
        for (int i = 0; i < redRobotCount; i++)
        {
            RedRobot *robot = [RedRobot node];
            [_actors addChild:robot];
            [_robots addObject:robot];
            
            int minX = SCREEN.width + robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int maxX = mapWidthInPixel - robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int minY = robot.centerToBottom;
            int maxY = mapFloorHeightInPixel + robot.centerToBottom;
            
            robot.scaleX = -1;
            robot.position = ccp(random_range(minX, maxX), random_range(minY, maxY));
            robot.desiredPosition = robot.position;
            [robot idle];
        }
        
        //create yellow robots
        for (int i = 0; i < yellowRobotCount; i++)
        {
            YellowRobot *robot = [YellowRobot node];
            [_actors addChild:robot];
            [_robots addObject:robot];
            
            int minX = SCREEN.width + robot.centerToSides + roundOfBackground_Current*mapWidthInPixel + mapWidthInPixel*1/4;
            int maxX = mapWidthInPixel - robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int minY = robot.centerToBottom;
            int maxY = mapFloorHeightInPixel + robot.centerToBottom;
            
            robot.scaleX = -1;
            robot.position = ccp(random_range(minX, maxX), random_range(minY, maxY));
            robot.desiredPosition = robot.position;
            [robot idle];
        }
        
        //create blue robots
        for (int i = 0; i < blueRobotCount; i++)
        {
            BlueRobot *robot = [BlueRobot node];
            [_actors addChild:robot];
            [_robots addObject:robot];
            
            int minX = SCREEN.width + robot.centerToSides + roundOfBackground_Current*mapWidthInPixel + mapWidthInPixel*1/2;
            int maxX = mapWidthInPixel - robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int minY = robot.centerToBottom;
            int maxY = mapFloorHeightInPixel + robot.centerToBottom;
            
            robot.scaleX = -1;
            robot.position = ccp(random_range(minX, maxX), random_range(minY, maxY));
            robot.desiredPosition = robot.position;
            [robot idle];
        }
        
        //create purple robots
        for (int i = 0; i < purpleRobotCount; i++)
        {
            PurpleRobot *robot = [PurpleRobot node];
            [_actors addChild:robot];
            [_robots addObject:robot];
            
            int minX = SCREEN.width + robot.centerToSides + roundOfBackground_Current*mapWidthInPixel + mapWidthInPixel*3/4;
            int maxX = mapWidthInPixel - robot.centerToSides + roundOfBackground_Current*mapWidthInPixel;
            int minY = robot.centerToBottom;
            int maxY = mapFloorHeightInPixel + robot.centerToBottom;
            
            robot.scaleX = -1;
            robot.position = ccp(random_range(minX, maxX), random_range(minY, maxY));
            robot.desiredPosition = robot.position;
            [robot idle];
        }
        
    }
    
    //Meng: once ninja is in the next map and has already pass winSize.width/2, we can assign createNewMap TRUE for creating the next new map. Why winSize.width/2? Because in that position, ninja cannot walk back to previous map.
    if((_hero.position.x >((roundOfBackground_Current+1)*mapWidthInPixel+winSize.width/2))
       &&(createNewMap==FALSE))
    {
        createNewMap=TRUE;
        roundOfBackground_Current+=1;
    }
}



-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //Meng: if ninja's position is below the middle of width of winSize, then set view stay on the middle of windows; if ninja's position is at the middle of width of winSize, then set view on ninja.
    //int x = MAX(position.x, winSize.width / 2 + roundOfBackground_Current*mapWidthInPixel);
    //int y = MAX(position.y, winSize.height / 2);
    
    unsigned int x;
    unsigned int y;
    if(position.x < heroFarPosition_x)
    {
        x=heroFarPosition_x;
    }
    else if(position.x >= heroFarPosition_x)
    {
        x=position.x;
    }
    
    if(position.y < winSize.height / 2)
    {
        y=winSize.height / 2;
    }
    else if(position.y >= winSize.height / 2)
    {
        y=position.y;
    }

    //Meng: if hero is not closed to the end of background picture, we want to view the ninja; if hero is closed to the end of background picture, we want to view the middle of the winsize.
    //Meng: because we want the background never ends, so we don't need the codes below anymore;or, our view would just stop in the last winsize of the first round of the background.
    //x = MIN(x, mapWidthInPixel - winSize.width / 2);
    //y = MIN(y, mapHeightInPixel - winSize.height/2);
    
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
    RedRobot *robot;
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
                    
                    if([robot isKindOfClass:[RedRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=ATTACKCHANCE_RED_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    else if([robot isKindOfClass:[YellowRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=ATTACKCHANCE_YELLOW_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    else if([robot isKindOfClass:[BlueRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=ATTACKCHANCE_BLUE_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    else if([robot isKindOfClass:[PurpleRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=ATTACKCHANCE_PURPLE_NINJA)
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
                        [robot idle];
                    }
                }
                else if ((distance_x > 50)
                         &&(distance_x <= SCREEN.width))
                {
                    //Meng: in this case, robot can have a chance to walk to hero.
                    robot.nextDecisionTime = CURTIME + frandom_range(0.5, 1.0);
                    
                    if([robot isKindOfClass:[RedRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=WALKCHANCE_RED_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    else if([robot isKindOfClass:[YellowRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=WALKCHANCE_YELLOW_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    else if([robot isKindOfClass:[BlueRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=WALKCHANCE_BLUE_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    else if([robot isKindOfClass:[PurpleRobot class]])
                    {
                        randomChoice = random_range(1, 100);
                        if(randomChoice<=WALKCHANCE_PURPLE_NINJA)
                        {
                            randomChoice=0;
                        }
                    }
                    
                    
                    
                    if (randomChoice == 0)
                    {
                        CGPoint moveDirection = ccpNormalize(ccpSub(_hero.position, robot.position));
                        [robot walkWithDirection:moveDirection];
                    }
                    else
                    {
                        [robot idle];
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
            if([robot isKindOfClass:[RedRobot class]])
            {
                gGameScore += MONSTER_POINTS_RED_NINJA;
            }
            else if([robot isKindOfClass:[YellowRobot class]])
            {
                gGameScore += MONSTER_POINTS_YELLOW_NINJA;
            }
            else if([robot isKindOfClass:[BlueRobot class]])
            {
                gGameScore += MONSTER_POINTS_BLUE_NINJA;
            }
            else if([robot isKindOfClass:[PurpleRobot class]])
            {
                gGameScore += MONSTER_POINTS_PURPLE_NINJA;
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

- (void) fruitDrop: (RedRobot *)robot
{
    int randomChoice = 0;
    
    if([robot isKindOfClass:[RedRobot class]])
    {
        randomChoice = random_range(1, 100);
        if(randomChoice<=FRUIT_DROP_CHANCE_RED_NINJA)
        {
            randomChoice=0;
        }
    }
    else if([robot isKindOfClass:[YellowRobot class]])
    {
        randomChoice = random_range(1, 100);
        if(randomChoice<=FRUIT_DROP_CHANCE_YELLOW_NINJA)
        {
            randomChoice=0;
        }
    }
    else if([robot isKindOfClass:[BlueRobot class]])
    {
        randomChoice = random_range(1, 100);
        if(randomChoice<=FRUIT_DROP_CHANCE_BLUE_NINJA)
        {
            randomChoice=0;
        }
    }
    else if([robot isKindOfClass:[PurpleRobot class]])
    {
        randomChoice = random_range(1, 100);
        if(randomChoice<=FRUIT_DROP_CHANCE_PURPLE_NINJA)
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
