//
//  PageHighscoreViewController.h
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
#import "Highscore.h"
#import "Score.h"
#import "DateTimeUtility.h"
#import "LogUtility.h"
#import "SoundManager.h"

@interface PageHighscoreViewController : PageBaseViewController<UITableViewDelegate, UITableViewDataSource> {

    IBOutlet UITableView *_scoresTableView;
    
    @private
    NSArray *_scores;
}

-(void) reload;

-(IBAction) backTapped:(id) sender;
-(IBAction) clearTapped:(id)sender;

@end
