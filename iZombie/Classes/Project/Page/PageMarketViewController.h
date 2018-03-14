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
#import "Avatar.h"
#import "UIImageManager.h"
#import "Hit.h"
#import "Item.h"
#import "Fire.h"
#import "LogUtility.h"
#import "SoundManager.h"

@interface PageMarketViewController : PageBaseViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {

    IBOutlet UITableView *_avatarTableView;
    IBOutlet UITableView *_fireTableView;
    IBOutlet UITableView *_hitTableView;
    
    IBOutlet UILabel *_moneyLabel;
    
    NSArray *_avatars;
    NSArray *_fires;
    NSArray *_hits;
    
    Item *_buyItem;
    NSNumber *_buyIndex;
    
    UIImageView *checkImageView; //Meng added. It is used for restoring a "check mark" on weapons.
    //UIImageView *checkImageView_character; //Meng added. It is used for restoring a "check mark" on character.
    UITableViewCell *cell_character;//Meng added. It is used for drawing a "check mark" on character cell.
    
    @private
}

-(void) reloadAvatar;
-(void) reloadFire;
-(void) reloadHit;

-(void) reloadMoney;

-(IBAction) backTapped:(id)sender;
-(IBAction) playTapped:(id)sender;

@end
