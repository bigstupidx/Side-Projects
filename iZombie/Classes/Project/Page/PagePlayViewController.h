//
//  PagePlayViewController.h
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PageBaseViewController.h"
#import "PageMainViewController.h"
#import "PlayWindow.h"
#import "UIUtility.h"
#import "LogUtility.h"
#import "Constants.h"

#import "MobclixAdView.h"

@interface PagePlayViewController : PageBaseViewController<UIAlertViewDelegate> {

    BOOL _alertView;
    
}


-(IBAction) leftTapped:(id) sender;
-(IBAction) leftReleased:(id) sender;
-(IBAction) rightTapped:(id) sender;
-(IBAction) rightReleased:(id) sender;
-(IBAction) fireTapped:(id) sender;
-(IBAction) hitTapped:(id) sender;
-(IBAction) pauseTapped:(id)sender;

-(void) pause;
-(void) resume;

@end
