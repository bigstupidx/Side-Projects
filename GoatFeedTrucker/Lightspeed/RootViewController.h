//
//  RootViewController.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-06.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobclixAds.h"



@interface RootViewController : UIViewController <UIAlertViewDelegate>
{
    NSMutableData *responseData;
    MobclixAdView* adView;
    
    UIButton *adCloseButton;
	
    UIButton *restoreIAPButton;
    
    //	ADBannerView *_adBannerView;
	BOOL bannerIsVisible;
    UIImage *fuelFiller;
    UIImageView *fuelFillerView;
    
    UIViewController *tempVC;
    
}

- (void) adCloseButtonCallback;
- (void) buyProduct;
- (void) setAdViewHidden: (BOOL) value;
- (void) purchaseAdRemovalCallback;
- (void) getChartBoostFeaturedAd;
- (void) getChartBoostMoreAds;
- (void) getMoreGamesCallback;
//-(void) freeGameButtonClicked:(id)sender;
- (void)dismiss;

@property(nonatomic,retain) MobclixAdView* adView;

@end
