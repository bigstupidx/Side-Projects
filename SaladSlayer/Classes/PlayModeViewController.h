//
//  PlayModeViewController.h
//

#import <UIKit/UIKit.h>
#import "FadingViewController.h"
#import "Audio.h"
#import "GLViewController.h"
#import "GADBannerView.h"

@class FadingViewController;
@class Audio;
@class GLViewController;

@interface PlayModeViewController : FadingViewController {
    GADBannerView *bannerView_;
	IBOutlet UIImageView *imgBackground;
	IBOutlet UIImageView *imgSwords;
	IBOutlet UIImageView *imgPanel;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton *btnBack;
}

#pragma mark UI Events

-(void) selectOption: (id) sender;

-(void) startGameMode: (int) mode;

-(IBAction) back;

@end