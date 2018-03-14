//
//  CustomizeViewController.h
//

#import <UIKit/UIKit.h>
#import "FadingViewController.h"
#import "Audio.h"

@class FadingViewController;
@class Audio;

@interface CustomizeViewController : FadingViewController {
	IBOutlet UIImageView *imgBackground;
	IBOutlet UIImageView *imgSwords;
	IBOutlet UIImageView *imgPanel;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton *btnBack;
}

#pragma mark UI Events

-(void) selectOption: (id) sender;

-(IBAction) back;

@end