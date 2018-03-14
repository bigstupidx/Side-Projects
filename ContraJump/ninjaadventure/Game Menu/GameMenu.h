//
//  GameScene.h
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "HudLayer.h"
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MobclixAds.h"
#import <RevMobAds/RevMobAds.h>

#import "GameCenterManager.h"

@class Game_CenterViewController;

@interface GameMenu : CCLayer <UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate, RevMobAdsDelegate>{
        CCSpriteBatchNode *_menuButton;
        GameCenterManager *gameCenterManager;
        int64_t  currentScore;
        NSString* currentLeaderBoard;
        IBOutlet UILabel *currentScoreLabel;
}


@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, retain) UILabel *currentScoreLabel;


- (IBAction) reset;
- (IBAction) showLeaderboard;
- (IBAction) showAchievements;
- (IBAction) submitScore;
- (IBAction) increaseScore;


- (void) checkAchievements;

+(id) scene;

@end
