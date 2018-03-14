//
//  PageTitleViewController.h
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
#import "LogUtility.h"
#import "InAppPurchaseManager.h"

#import "Globals.h"

@interface PageInAppPurchaseViewController : PageBaseViewController {
    
    IBOutlet UIImageView *_imageViewInAppPurchaseBackground;
    IBOutlet UIButton *_hammerPurchase;
    IBOutlet UIButton *_axePurchase;
    IBOutlet UIButton *_chainsawPurchase;
    IBOutlet UIButton *_machineGunPurchase;
    IBOutlet UIButton *_laserGunPurchase;
    IBOutlet UIButton *_allWeaponPurchase;
    
    IBOutlet UIButton *_hammerOwner;
    IBOutlet UIButton *_axeOwner;
    IBOutlet UIButton *_chainsawOwner;
    IBOutlet UIButton *_machineGunOwner;
    IBOutlet UIButton *_laserGunOwner;
    IBOutlet UIButton *_allWeaponOwner;
    
    IBOutlet UIButton *_restore;
    IBOutlet UIButton *_ok;
    
}


-(IBAction) axePurchaseTapped: (id) sender;
-(IBAction) hammerPurchaseTapped: (id) sender;
-(IBAction) chainsawPurchaseTapped: (id) sender;
-(IBAction) machineGunPurchaseTapped: (id) sender;
-(IBAction) laserGunPurchaseTapped: (id) sender;
-(IBAction) allWeaponPurchaseTapped: (id) sender;
-(IBAction) restoreTapped: (id) sender;
-(IBAction) okTapped: (id) sender;


-(void) axePurchaseStatusUpdate;
-(void) hammerPurchaseStatusUpdate;
-(void) chainsawPurchaseStatusUpdate;
-(void) machineGunPurchaseStatusUpdate;
-(void) laserGunPurchaseStatusUpdate;
-(void) allWeaponPurchaseStatusUpdate;

@end
