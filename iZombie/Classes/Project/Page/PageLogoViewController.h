//
//  PageLogoViewController.h
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
#import "LogUtility.h"

@interface PageLogoViewController : PageBaseViewController {

	IBOutlet UIImageView *_imageViewLogo;
	
	NSTimer *_timerMenu;
}

//-(void) gotoMenu:(NSTimer *) timer;

@end
