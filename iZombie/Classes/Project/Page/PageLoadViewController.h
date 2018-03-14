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

@interface PageLoadViewController : PageBaseViewController {

	IBOutlet UIImageView *_imageViewLoad;
	
	NSTimer *_timerPlay;
}

-(void) gotoPlay:(NSTimer *) timer;

@end
