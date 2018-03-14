//
//  AdsManager.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-12.
//  Copyright 2012 NetMatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "MobclixAds.h"
#import <RevMobAds/RevMobAds.h>
#import "ChartBoost.h"
#import "PushNotificationManager.h"
#import <StoreKit/StoreKit.h>
#import "TapjoyConnect.h"

@interface AdsManager : CCLayer <RevMobAdsDelegate, UIAlertViewDelegate,PushNotificationDelegate,TJCAdDelegate, TJCVideoAdDelegate> {
    MobclixAdView *adView;
    BOOL adStarted;
    UIButton* adCloseButton;
    PushNotificationManager *pushManager;
    BOOL deallocCalled;
    
    UIViewController* viewController;
}

-(void) loadPLISTValues;

-(UIViewController*) getRootViewController;
-(void) presentViewController:(UIViewController*)vc;
-(void) startBannerAd;
-(void) showBannerAd;
-(void) hideBannerAd;
-(void) showAdOnActive;
-(void) showAdOnPause;
-(void) showAdOnGameOver;
-(void) showAd: (int) value;
-(void) cancelAd;

-(void) showAdOnLoad;

- (void)dealloc;

- (void) saveAdRemovalStatus;

-(void) purchaseAdNew;

-(void) start;
-(void) startMobclix;
-(void) startRevMobAds;
-(void) startTapJoyConnect;
-(void) startChartBoost;
-(void) startPushWoosh:(NSDictionary *)launchOptions;

-(void) clickFreeGameButton;
-(void) showChartBoost;
-(void) showChartBoostMore;
-(void)tjcConnectSuccess:(NSNotification*)notifyObj;
-(void)tjcConnectFail:(NSNotification*)notifyObj;
-(void) handlePushRegistration:(NSData *)deviceToken;
-(void) handlePushReceived:(NSDictionary *)userInfo;
-(void) purchaseAdRemovalCallback;

- (void)timeout:(id)arg;
- (void) buyProduct;
- (void)productPurchaseFailed:(NSNotification *)notification;
- (void) purchaseAdRemovalCallback;

-(UIViewController*) getRootViewController;
-(void) presentViewController:(UIViewController*)vc;

- (void)productsLoaded:(NSNotification *)notification;
- (void)productPurchased:(NSNotification *)notification;
- (void)productPurchaseFailed:(NSNotification *)notification;

//chartboost delegate methods
// Called before requesting an interstitial from the back-end
- (BOOL)shouldRequestInterstitial:(NSString *)location;

// Called when an interstitial has been received, before it is presented on screen
// Return NO if showing an interstitial is currently inappropriate, for example if the user has entered the main game mode
- (BOOL)shouldDisplayInterstitial:(NSString *)location;

// Called when the user dismisses the interstitial
- (void)didDismissInterstitial:(NSString *)location;

// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location;

// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(NSString *)location;

// Called when an interstitial has failed to come back from the server
// This may be due to network connection or that no interstitial is available for that user
- (void)didFailToLoadInterstitial:(NSString *)location;

+(AdsManager*)sharedAdsManager;

@property (retain, nonatomic) MobclixAdView *adView;
@property (assign, nonatomic) BOOL adStarted;
@property (nonatomic, retain) PushNotificationManager *pushManager;

@property (assign, nonatomic) int needsUpdating;
@property (assign, nonatomic) int isInReview;
@property (assign, nonatomic) int adBannerOn;
@property (assign, nonatomic) int adOnFreeGame;
@property (assign, nonatomic) int adOnPause;
@property (assign, nonatomic) int adOnActive;
@property (assign, nonatomic) int adOnLoad1;
@property (assign, nonatomic) int adOnLoad2;
@property (assign, nonatomic) int adOnGameOver;
@end
