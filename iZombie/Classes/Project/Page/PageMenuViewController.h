//
//  PageTitleViewController.h
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Preferences.h"
#import "PageBaseViewController.h"
#import "PageMainViewController.h"
#import "PagePlayViewController.h"
#import "Avatar.h"
#import "Hit.h"
#import "Fire.h"
#import "Highscore.h"
#import "Score.h"
#import "LogUtility.h"
#import "SoundManager.h"
#import "GameCenterManager.h"


@interface PageMenuViewController : PageBaseViewController<GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate> {

    IBOutlet UIImageView *_imageViewSplash;
    IBOutlet UIButton *_buttonResume;
    IBOutlet UILabel *_labelHighscore;
    IBOutlet UIButton *_buttonSoundOn;
    IBOutlet UIButton *_buttonSoundOff;
    IBOutlet UIButton *_freeGames;
    IBOutlet UIButton *_gameCenter;
    NSString* currentLeaderBoard; //Meng added
}


-(IBAction) resumeTapped:(id) sender;
-(IBAction) playTapped:(id) sender;

-(IBAction) highscoreTapped:(id) sender;
-(IBAction) soundOnTapped:(id) sender;
-(IBAction) soundOffTapped:(id) sender;
-(IBAction) freeGamesTapped: (id) sender;
-(IBAction) gameCenterTapped: (id) sender;

@property (nonatomic, retain) NSString* currentLeaderBoard;

@end
