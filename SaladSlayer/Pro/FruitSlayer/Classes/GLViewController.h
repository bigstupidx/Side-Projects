//
//  GLViewController.h
//

#import <UIKit/UIKit.h>
#import "GLView.h"
#import "FadingViewController.h"
#import <GameKit/GameKit.h>

@class GLView;
@class FadingViewController;

@interface GLViewController : FadingViewController {
	bool wentToSecondaryWindow;
	int mode;
}

@property (nonatomic, assign) bool wentToSecondaryWindow;
@property (nonatomic, assign) int mode;

-(void) quitToMainMenu;

@end