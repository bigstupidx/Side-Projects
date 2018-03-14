//
//  GameScene.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameMenu.h"
#import "GameScene.h"

#import "Flurry.h"
#import "InAppPurchaseManager.h"
#import "OptionsMenulayer.h"
#import "SimpleAudioEngine.h"

#import "AdsManager.h"

#import "AppSpecificValues.h"
#import "GameCenterManager.h"

@implementation GameMenu


@synthesize gameCenterManager;
@synthesize currentScore;
@synthesize currentLeaderBoard;
@synthesize currentScoreLabel;

+(id) scene
{
	CCScene *scene = [CCScene node];
    
    GameMenu *layer = [GameMenu node];

    [scene addChild: layer];
    
	return scene;
}

-(id)init {
    if( (self=[super init] )) {
        
        self.currentLeaderBoard = kLeaderboardID;
        self.currentScore = 0;
        
        //Meng: This way has bugs!
        /*
        if ([GameCenterManager isGameCenterAvailable]) {
            
            self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [self.gameCenterManager setDelegate:self];
            [self.gameCenterManager authenticateLocalUser];
        } else {
            
            // The current device does not support Game Center.
        }
        */
        
        //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"background_1_1.mp3"];
         //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_1_1.mp3"];
        
        CCMenu * myMenu;
        
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_PlayGame.png"
                                                             selectedImage: @"Menu_Button_PlayGame_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(goToGameScene:)];
        myMenu = [CCMenu menuWithItems:menuItem1, nil];
        myMenu.position = ccp(100, 240);
        [myMenu alignItemsVertically];
        [self addChild:myMenu z:3];
        
        
        CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Leaderboard.png"
                                                             selectedImage: @"Menu_Button_Leaderboard_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(leaderboard:)];
        myMenu = [CCMenu menuWithItems:menuItem2, nil];
        myMenu.position = ccp(240, 240);
        [myMenu alignItemsVertically];
        [self addChild:myMenu z:3];
        
        
        CCMenuItemImage * menuItem3 = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Options.png"
                                                             selectedImage: @"Menu_Button_Options_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(options:)];
        myMenu = [CCMenu menuWithItems:menuItem3, nil];
        myMenu.position = ccp(100, 190);
        [myMenu alignItemsVertically];
        [self addChild:myMenu z:3];
        
        
        
        CCMenuItemImage * menuItem4 = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Restore.png"
                                                             selectedImage: @"Menu_Button_Restore_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(restore:)];
        myMenu = [CCMenu menuWithItems:menuItem4, nil];
        myMenu.position = ccp(100, 140);
        [myMenu alignItemsVertically];
        [self addChild:myMenu z:3];
        
        CCMenuItemImage * menuItem5 = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_MoreGames.png"
                                                             selectedImage: @"Menu_Button_MoreGames_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(moreGame:)];
        myMenu = [CCMenu menuWithItems:menuItem5, nil];
        myMenu.position = ccp(100, 90);
        [myMenu alignItemsVertically];
        [self addChild:myMenu z:3];
     
        CCSprite* background = [CCSprite spriteWithFile:@"Menu_Main.png"];
        background.anchorPoint = CGPointMake(0, 0);
        background.position = ccp(0,0);
        [self addChild:background z:2];
        
        /*
         CCMenuItem *Play = [CCMenuItemFont itemFromString:@"Click here to play"
                                                   target:self
                                                 selector:@selector(goToGameScene:)];
         
         CCMenu *menu = [CCMenu menuWithItems: Play, nil];
         menu.position = ccp(240, 60);
         [menu alignItemsVerticallyWithPadding:10];
         
         [self addChild:menu];
         */
        
        [self authenticateLocalPlayer];
    }
    return self;
}

-(void) goToGameScene: (id) sender {
    
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade
                   transitionWithDuration:1
                   scene:[GameScene node]
                   ]];
}

-(void) goToMoreGames: (id) sender {
    
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade
                   transitionWithDuration:1
                   scene:[GameScene node]
                   ]];
}

- (void) options: (id) sender
{
    [[CCDirector sharedDirector] pushScene:[OptionsMenuLayer scene]]; //push main menu and go to 'Options' menu
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated)
        return;
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil)
        {
            NSLog(@"Authentication successful");
        }
        else {
            NSLog(@"Authentical failed");
        }
    }];
    
}

- (void) leaderboard: (id) sender
{
    [Flurry logEvent:@"MainMenu_LeaderButton"];
    
    [self authenticateLocalPlayer];
    
 	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL)
	{
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
		leaderboardController.leaderboardDelegate = self;
        [mainWindow.rootViewController presentModalViewController:leaderboardController animated:YES];
	}

}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[mainWindow.rootViewController dismissModalViewControllerAnimated: YES];
	[viewController release];
}


- (void) restore: (id) sender
{
    [Flurry logEvent:@"MainMenu_RestoreButton"];
    
    //restore the completedtransactions
	[[InAppPurchaseManager sharedInAppManager] restoreCompletedTransactions];
}


- (void) moreGame: (id) sender
{
    [[AdsManager sharedAdsManager] clickFreeGameButton];
}






@end
