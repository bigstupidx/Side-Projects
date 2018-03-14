//
//  GameScene.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

+(id) scene
{
	CCScene *scene = [CCScene node];
    
    
	GameLayer *gameLayer = [GameLayer node];
	[scene addChild: gameLayer];
    
    HudLayer* hudLayer = [HudLayer node];
    [scene addChild:hudLayer z:1];

    hudLayer.dPad.delegate = gameLayer;
    gameLayer.hud = hudLayer;
    
	return scene;
}

-(id)init {
    if ((self = [super init])) {
        GameLayer *gameLayer = [GameLayer node];
        [self addChild: gameLayer];
        
        HudLayer* hudLayer = [HudLayer node];
        [self addChild:hudLayer z:1];
        
        hudLayer.dPad.delegate = gameLayer;
        gameLayer.hud = hudLayer;
        
    }
    return self;
}

@end
