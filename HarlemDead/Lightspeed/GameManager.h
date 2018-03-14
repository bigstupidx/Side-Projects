//
//  GameManager.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-11.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "RootViewController.h"


enum{
    kMainMenuScene,
    kOptionsMenuScene,
    kGameScene,
    kMultiplayerScene,
    kSingleplayerScene
};

@interface GameManager : NSObject{

    int currentScene;
    RootViewController* viewController;
}



@property (readwrite) int currentScene;

+ (GameManager*) sharedGameManager;
- (void)runSceneWithID:(int) sceneID;


@end
