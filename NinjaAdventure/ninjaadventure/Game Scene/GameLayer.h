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
#import "SimpleDPad.h"
#import "HudLayer.h"
#import "Fruit.h"

@interface GameLayer : CCLayer <SimpleDPadDelegate>
{
    CCLayer* mapLayer;
    CCSpriteBatchNode *_actors;
    Hero *_hero;
    BOOL createNewMap; //Meng: Yes-Create a new map because hero gets closed to the end of current map; No-Don't create a new map.
    unsigned int heroFarPosition_x; //Meng: this variable records the most far position of hero ever reached.
}

@property(nonatomic,weak)HudLayer *hud;
@property(nonatomic,strong)CCArray *robots;
@property(nonatomic,strong)CCArray *fruits;
@property(nonatomic,weak)HealthBar  *hBar;

@end
