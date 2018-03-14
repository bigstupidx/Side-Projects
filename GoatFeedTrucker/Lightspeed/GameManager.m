//
//  GameManager.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-11.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "GameManager.h"
#import "MenuScene.h"
#import "GameScene.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;
@synthesize currentScene;



+(GameManager*) sharedGameManager {
    @synchronized([GameManager class])
    {
        if (!_sharedGameManager)
            [[self alloc] init];
        return _sharedGameManager;
    }
    return nil;
}

+(id) alloc{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"attempted to allocated second instance of gm");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
}


-(void) runSceneWithID:(int)sceneID
{
    int oldScene = currentScene;
    id sceneToRun = nil;
    
    
    //MenuScene *menuScene = [MenuScene node];
	//[[CCDirector sharedDirector] runWithScene:menuScene];
    switch (sceneID) {
        case kMainMenuScene:
            sceneToRun = [MenuScene node];
            break;
        
        case kMultiplayerScene:
            sceneToRun = [GameScene node];
            
        default:
            CCLOG(@"Unknown ID, cannot switch scene");
            return;
            break;
    }
    
    if (sceneToRun == nil){
        //revert back sine no new scene was found
        currentScene = oldScene;
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil){
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    }
     else {
         [[CCDirector sharedDirector] replaceScene:sceneToRun];
     }
    
    
    
}

@end
