//
//  FadingViewController.h
//
//  Created by Craig Hockenberry on 9/12/10.
//  Copyright 2010 The Iconfactory, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface FadingViewController : UIViewController {
	FadingViewController *presentingViewController;
	FadingViewController *presentedViewController;
	FadingViewController *replacementViewController;
	
	UIView *overlay;
}

// NOTE: the fading view controller maintains a doubly-linked list of view controllers. Each view controller has a presentingViewController,
// which points to the previous view controller (the parent, which will be nil for the root view controller.) If a view controller has
// presented another view controller, it will have an instance of presentedViewController.
//
// The list of view controllers is initialized with -setRootFadingViewController. View controllers are added to the list with
// -presentFadingViewController: and removed with -dismissFadingViewController. Animations are handled automatically and the override
// methods below are called at the appropriate time (e.g. "will" before the animation, "did" after the animation.)
//
// The top-most view controller can be replaced using -replaceFadingViewControllerWith:. This is used, for example, during level selection
// when the selection view controller is replaced with an instance of the game controller.

@property (nonatomic, assign, readonly) FadingViewController *presentingViewController;
@property (nonatomic, retain, readonly) FadingViewController *presentedViewController;

- (void)setRootFadingViewController;
- (void)presentFadingViewController:(FadingViewController *)viewController;
- (void)replaceFadingViewControllerWith:(FadingViewController *)newPresentedViewController;
- (void)dismissFadingViewController;

// overrides

- (void)viewWillFadeIn; // called when the view is about to be presented; default does nothing
- (void)viewDidFadeIn; // called when the view has been presented on screen; default does nothing

- (void)viewWillFadeOut; // called when the view is about to be dismissed; default does nothing
- (void)viewDidFadeOut; // called after the view was dismissed from the screen; default does nothing

@end
