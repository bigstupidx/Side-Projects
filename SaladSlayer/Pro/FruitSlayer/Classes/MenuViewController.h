//
//  MenuViewController.h
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "FadingViewController.h"
#import "Audio.h"
#import "GameKitLibrary.h"
#import "OptionsViewController.h"
#import "PlayModeViewController.h"
#import "HelpViewController.h"
#import "Constants.h"

@class FadingViewController;
@class Audio;
@class GameKitLibrary;
@class OptionsViewController;
@class PlayModeViewController;
@class HelpViewController;

@interface MenuViewController : FadingViewController <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate> {
	IBOutlet UIImageView *imgBackground;
	IBOutlet UIImageView *imgLogo;
	IBOutlet UIImageView *imgSwords;
	IBOutlet UIImageView *imgPanel;
	IBOutlet UIButton *btnPlay;
	IBOutlet UIButton *btnOptions;
	IBOutlet UIButton *btnScores;
	IBOutlet UIButton *btnHelp;
}

#pragma mark Animations

-(void) resetControls;

-(void) animateControlsIn;

#pragma mark UI Events

-(IBAction) startGame;

-(IBAction) showOptions;

-(IBAction) showAchievements;

-(IBAction) showHelp;

@end