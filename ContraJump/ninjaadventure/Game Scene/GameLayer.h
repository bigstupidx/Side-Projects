//
//  GameLayer.h
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Hero.h"
#import "HudLayer.h"
#import "Fruit.h"

@interface GameLayer : CCLayer 
{
    CCLayer* mapLayer;
    CCSpriteBatchNode *_actors;
    Hero *_hero;
    BOOL createNewMap; //Meng: Yes-Create a new map because hero gets closed to the end of current map; No-Don't create a new map.
    unsigned int heroFarPosition_y; //Meng: this variable records the highest position of hero ever reached.
    
    CCTMXTiledMap *tiledMap; //Meng added
    CCTMXLayer *walls;  //Meng added
    CCTMXLayer *floors;  //Meng added
    CCTMXLayer *hazard_points;  //Meng added
    CCTMXLayer *jump_points;  //Meng added
    
    CGPoint touchLocation; //Meng added
    
    double seconds_current; //Meng added
    double seconds_last;  //Meng added
    double seconds_during; //Meng added
    
    double map_seconds_current; //Meng added
    double map_seconds_last;  //Meng added
    unsigned int map_seconds_during; //Meng added
    
    NSMutableArray *_bullet; //Meng added
    
    CGPoint realDest; //Meng added
    float realMoveDuration; //Meng added
}

@property(nonatomic,weak)HudLayer *hud;
@property(nonatomic,strong)CCArray *robots;
@property(nonatomic,strong)CCArray *fruits;
@property(nonatomic,weak)HealthBar  *hBar;

@end
