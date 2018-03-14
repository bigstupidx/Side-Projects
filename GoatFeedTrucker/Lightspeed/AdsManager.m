//
//  AdsManager.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-12.
//  Copyright 2012 NetMatch. All rights reserved.
//

#import "AdsManager.h"

#import "InAppPurchaseManager.h"
#import "Reachability.h"

@implementation AdsManager

#define TAPJOY_APP_ID @"80876ffa-0ec0-4ad0-8f24-4d4b7d8f610d"
#define TAPJOY_SECRET_KEY @"Btka5ggwqniSwOJ08RJX"

#define CHARTBOOST_ID @"5150b1d616ba479929000029"
#define CHARTBOOST_APP_SIGNATURE @"1b7423deda23d5fb01d29e4cf3ddf8483643f575"

#define MOBCLIX_ID @"352e0631-fc14-4dfe-9d92-7d428ec05d46"

#define REVMOBADS_ID @"5150b28a5236b61700000004"
#define PLIST_URL @"http://iosgames.slightlysocial.com/goatfeedtrucker.plist"

#define AD_OFF 0
#define CHARTBOOST_VALUE 1
#define CHARTBOOST_MORE_VALUE 2
#define REVMOB_POPUP_VALUE 3
#define REVMOB_FULLSCREEN_VALUE 4
#define MOBCLIX_VALUE 5


@synthesize adStarted;
@synthesize pushManager;
@synthesize adOnLoad1;
@synthesize adOnLoad2;
@synthesize adOnFreeGame;
@synthesize adOnGameOver;
@synthesize adOnActive;
@synthesize adOnPause;
@synthesize isInReview;
@synthesize adBannerOn;

@synthesize needsUpdating;
static AdsManager *_sharedAdsManager = nil;

// Helper methods

-(UIViewController*) getRootViewController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void) presentViewController:(UIViewController*)vc
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentModalViewController:vc animated:YES];
}

-(void) handlePushReceived:(NSDictionary *)userInfo{
    [pushManager handlePushReceived:userInfo];
}

-(void) handlePushRegistration:(NSData *)deviceToken{
    [pushManager handlePushRegistration:deviceToken];
}

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.slightlysocial.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

//creates the banner ad
-(void) startBannerAd{
    
    if (adBannerOn <= 0)
        return;
    
    bool adsRemoved = [[[NSUserDefaults standardUserDefaults] valueForKey:@"badsremoved"] boolValue];
    if (adsRemoved)
        return;
    
    adCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(300, 40, 16, 17)];
        
    }
    else
    {
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton-ipad.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(720, 70, 40, 41)];        
    }
    
    
    
    UIViewController* mobVC=[[UIViewController alloc] init] ;
    [[[CCDirector sharedDirector] openGLView] addSubview:mobVC.view];
    //[[[CCDirector sharedDirector] openGLView] bringSubviewToFront:adView];
    //mobVC.view bringSubviewToFront:<#(UIView *)#>
    //[self presentViewController:mobVC];
    //[[[CCDirector sharedDirector] openGLView] addSubview:adView];
    
    [adCloseButton addTarget:self action:@selector(purchaseAdNew) forControlEvents:UIControlEventTouchUpInside];
    
     [[[CCDirector sharedDirector] openGLView] addSubview:adCloseButton];
    
    if (![[InAppPurchaseManager sharedInAppManager]  storeLoaded])
        [adCloseButton setHidden:TRUE];
}

- (void) purchaseAdNew
{
    //SKProduct *prod = [[InAppPurchaseManager sharedInAppManager] getRemoveAdsProduct];
    
    [[InAppPurchaseManager sharedInAppManager] purchaseRemoveAds];
    
}


- (void)productPurchaseFailed:(NSNotification *)notification {
    
	NSLog(@"productPurchaseFailed");
	
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}

- (void)productsLoaded:(NSNotification *)notification {
	
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
	//    self.tableView.hidden = FALSE;    
	//	
	//    [self.tableView reloadData];
	
	NSLog(@"productsLoaded");
	
    if(!deallocCalled)
        [self buyProduct];
}

- (void)dealloc {
    deallocCalled = YES;
    [super dealloc];
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
	//    [self.tableView reloadData];    
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!" 
													 message:@"Banner ads are successfully removed"
													delegate:nil 
										   cancelButtonTitle:nil 
										   otherButtonTitles:@"OK", nil] autorelease];
	
	[alert show];
	
	[self saveAdRemovalStatus];	
}

- (void) saveAdRemovalStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:true forKey:@"badsremoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [adCloseButton setHidden:YES];
}



- (void)timeout:(id)arg {
	
	NSLog(@"Timeout");
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Timeout!" 
													 message:@""
													delegate:nil 
										   cancelButtonTitle:nil 
										   otherButtonTitles:@"OK", nil] autorelease];
	
	[alert show];	
}


//shows the banner ad at the top of the screen
-(void) showBannerAd {
    bool adsRemoved = [[[NSUserDefaults standardUserDefaults] valueForKey:@"badsremoved"] boolValue];
    if (!adsRemoved)
        return;
    [adCloseButton setHidden:NO];
}



-(void) hideBannerAd {
    [adCloseButton setHidden:YES];
}

-(void) cancelAd {
    // Can only cancel it if it exists
        [adCloseButton removeFromSuperview];
        adCloseButton = nil;
}
-(void) start {
    
    
}

-(void) startMobclix {

    if (!adStarted)
        adStarted = YES;
}

-(void) startRevMobAds{
    [RevMobAds startSessionWithAppID:REVMOBADS_ID];
}


-(void) showAdOnPause{
    
    [self showAd:adOnPause];
}

-(void) showAdOnActive{
    
    [self showAd:adOnActive];
}

-(void) showAdOnLoad{
    
    
    if (isInReview == 0)
        return;
    
    [self showAd:adOnLoad1];
    [self showAd:adOnLoad2];
}

-(void) showAdOnGameOver
{
    [self showAd:adOnGameOver];
}


- (BOOL)shouldRequestInterstitial:(NSString *)location{
    return TRUE;
}

- (BOOL)shouldDisplayInterstitial:(NSString *)location{
    return TRUE;
}

- (void)didDismissInterstitial:(NSString *)location{
    
}

- (void)didCloseInterstitial:(NSString *)location
{
    
}

- (void)didClickInterstitial:(NSString *)location{
    
}

// Called when an interstitial has failed to come back from the server
// This may be due to network connection or that no interstitial is available for that user
- (void)didFailToLoadInterstitial:(NSString *)location{
    
}


-(void) startPushWoosh:(NSDictionary *)launchOptions {
    //PushWoosh
    if (isInReview == 0)
        return;
    
    //initialize push manager instance
    pushManager = [[PushNotificationManager alloc] initWithApplicationCode:@"4fe9344a96de10.69739819" appName:@"Lightspeed Getaway" ];
    pushManager.delegate = self;
    
    [pushManager handlePushReceived:launchOptions];
    
}

-(void) loadPLISTValues{
    // Plist
    if (![self reachable])
    {
        //since there is no internet turn all of the adds off
        [self setAdOnPause:0];
        [self setAdOnActive:0];
        [self setIsInReview:0];
        [self setAdOnLoad1:0];
        [self setAdOnLoad2:0];
        [self setAdOnGameOver:0];
        [self setAdOnFreeGame:0];
        [self setAdBannerOn:0];
        return;
    }
    
    NSURL* url = [NSURL URLWithString:PLIST_URL];
    NSDictionary* plistsDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    
    
    
    //if we want to test with local PLIST
    /*
    NSBundle* bundle = [NSBundle mainBundle];
	NSString* plistPath = [bundle pathForResource:@"lsadsettings" ofType:@"plist"];
    NSDictionary *plistsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    */
    if (!plistsDictionary)
    {
        //no dictionary was found of ad settings
        return;
    }
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //used in prior versions for version checking
   /* NSString *latestVersion = [plistsDictionary valueForKey:@"LATEST_VERSION"];
    if (latestVersion && ![appVersion isEqualToString:latestVersion])
        self.needsUpdating = YES;*/
    
    NSDictionary* plistValues = [plistsDictionary valueForKey:appVersion];
    if (plistValues)
    {
        if ([[plistsDictionary valueForKey:@"NEEDS_UPDATING"] intValue] == 1)
        {
            self.needsUpdating = YES;
        }
        else
        {
            self.needsUpdating = NO;
        }
        
        //get the plistvalues specific to this app version
        [self setAdOnPause:[[plistValues valueForKey:@"AD_ON_PAUSE"] intValue]];
        [self setAdOnActive:[[plistValues valueForKey:@"AD_ON_ACTIVE"] intValue]];
        [self setIsInReview:[[plistValues valueForKey:@"IS_IN_REVIEW"] intValue]];
        [self setAdOnLoad1:[[plistValues valueForKey:@"AD_ON_LOAD_1"] intValue]];
        [self setAdOnLoad2:[[plistValues valueForKey:@"AD_ON_LOAD_2"] intValue]];
        [self setAdOnGameOver:[[plistValues valueForKey:@"AD_ON_GAMEOVER"] intValue]];
        [self setAdOnFreeGame:[[plistValues valueForKey:@"AD_ON_FREEGAME"] intValue]];
        [self setAdBannerOn:[[plistValues valueForKey:@"AD_BANNER_ON"] intValue]];
    }
    
    
    [self startMobclix];
    [self startRevMobAds];
    [self startTapJoyConnect];
    [self startChartBoost];
}

-(void) showAd: (int) value
{    
    if (isInReview == 0)
        return;
    
    if (value == AD_OFF)
        return;

    if(value == CHARTBOOST_VALUE) //Chartboost
    {
        [self showChartBoost];
    }
    else if (value == CHARTBOOST_MORE_VALUE)
     {
         [self showChartBoostMore];
     }
    else if(value == REVMOB_POPUP_VALUE) //RevMob
    {
        //[RevMobAds showPopupWithDelegate:self];
        
        [[RevMobAds session] showPopup];
    
    }
    else if(value == REVMOB_FULLSCREEN_VALUE) //RevMobFullScreen
    {
        [[RevMobAds session] showFullscreen];
    }
}

-(void) clickFreeGameButton {
    if (isInReview == 0)
        return;
    
    
    [self showAd:adOnFreeGame];
}

+(AdsManager*)sharedAdsManager
{
	@synchronized([AdsManager class])
	{
		if (!_sharedAdsManager)
			[[self alloc] init];
        
		return _sharedAdsManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([AdsManager class])
	{
		NSAssert(_sharedAdsManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedAdsManager = [[super alloc] init];
		return _sharedAdsManager;
	}
    
	return nil;
}

-(id)autorelease {
    [self cancelAd];
    
    return self;
}

-(id)init {

	return [super init];
}

@end
