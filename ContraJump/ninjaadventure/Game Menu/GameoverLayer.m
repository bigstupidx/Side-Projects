//
//  GameoverLayer.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-05.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "GameoverLayer.h"
#import "Globals.h"
#import "GameScene.h"
#import "AdsManager.h"
#import "GameMenu.h"

@implementation GameoverLayer

- (id) init
{
	self = [super init];

	if (self)
	{
        CCMenu * myMenu;
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage: @"btn_gameover_retry.png"
                                                             selectedImage: @"btn_gameover_retry_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(restartGame:)];
        
        myMenu = [CCMenu menuWithItems:menuItem1, nil];
        myMenu.position = ccp(180, 120);
        [self addChild:myMenu z:3];
        
        CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage: @"btn_gameover_mainmenu.png"
                                                             selectedImage: @"btn_gameover_mainmenu_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(exitToMainMenu:)];
        
        myMenu = [CCMenu menuWithItems:menuItem2, nil];
        myMenu.position = ccp(300, 120);
        [self addChild:myMenu z:3];
        
        
        CCSprite* backgroundNinja = [CCSprite spriteWithFile:@"Menu_GameOver.png"];
        backgroundNinja.anchorPoint = ccp(0,0);
        backgroundNinja.position = ccp(0,0);
        [self addChild:backgroundNinja z:2];
        
        [[AdsManager sharedAdsManager] showAdOnGameOver];
	}
	return self;
}

- (void) setScore: (int) s{
    //save score internally
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int oldHighScore = [[defaults valueForKey:tHIGHSCORE ] intValue];
    
    if (s > oldHighScore)
    {
        [defaults setInteger:s forKey:tHIGHSCORE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //attempt to save to game center
    [self saveScoreToGameCenter: s];
}

- (void) dealloc
{
	//[super dealloc];
}

- (void) restartGame: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:1.0 
										scene:[GameScene scene]
									withColor:ccWHITE]];
}


- (void) saveScoreToGameCenter: (int) score {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            //Add new score
            GKScore *myScoreValue = [[GKScore alloc] initWithCategory:LEADERBOARD_ID];
            myScoreValue.value = score;
            
            [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
                if(error != nil){
                    NSLog(@"Score Submission Failed");
                } else {
                    NSLog(@"Score Submitted");
                }
                
            }];
            
            /*
             //Update achievements
             if (score >= 25000)
             {
             GKAchievement *achievement;
             achievement= [[GKAchievement alloc] initWithIdentifier:@"aa.25000"];
             achievement.percentComplete = 100.0;
             
             if(achievement!= NULL)
             [achievement reportAchievementWithCompletionHandler: ^(NSError *error){
             if(error != nil){
             NSLog(@"Achievement failed");
             } else {
             NSLog(@"Achievement Success");
             }
             
             }];
             
             }
             else if (score >= 10000)
             {
             GKAchievement *achievement;
             achievement= [[GKAchievement alloc] initWithIdentifier:@"aa.10000"];
             achievement.percentComplete = 100.0;
             
             if(achievement!= NULL)
             [achievement reportAchievementWithCompletionHandler: ^(NSError *error){
             if(error != nil){
             NSLog(@"Achievement failed");
             } else {
             NSLog(@"Achievement Success");
             }
             
             }];
             
             }
             else if (score >= 5000)
             {
             GKAchievement *achievement;
             achievement= [[GKAchievement alloc] initWithIdentifier:@"aa.5000"];
             achievement.percentComplete = 100.0;
             
             if(achievement!= NULL)
             [achievement reportAchievementWithCompletionHandler: ^(NSError *error){
             if(error != nil){
             NSLog(@"Achievement failed");
             } else {
             NSLog(@"Achievement Success");
             }
             
             }];
             }
             */
        }
    }];
	
}

- (void) exitToMainMenu: (id) sender
{
	[[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:1.0 
										scene:[GameMenu scene]
									withColor:ccBLACK]];
	
	gGameSuspended = YES;
    
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


@end
