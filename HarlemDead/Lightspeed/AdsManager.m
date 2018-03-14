//
//  AdsManager.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-12.
//  Copyright 2012 NetMatch. All rights reserved.
//

#import "AdsManager.h"
#import "Mobclix.h"

#import "ChartBoost.h"
#import "InAppPurchaseManager.h"
#import "Reachability.h"

#import "Flurry.h"

@implementation AdsManager

#define TAPJOY_APP_ID @"9171b1ae-28a0-41ec-902b-ddf9b471a0c5"
#define TAPJOY_SECRET_KEY @"BfnGRtmzfBYHj4RTOS44"

#define CHARTBOOST_ID @"5150b1d616ba479929000029"
#define CHARTBOOST_APP_SIGNATURE @"1b7423deda23d5fb01d29e4cf3ddf8483643f575"

#define MOBCLIX_ID @"352e0631-fc14-4dfe-9d92-7d428ec05d46"

#define REVMOBADS_ID @"5150b28a5236b61700000004"
#define PLIST_URL @"http://iosgames.slightlysocial.com/harlem_dead.plist"

#define AD_OFF 0
#define CHARTBOOST_VALUE 1
#define CHARTBOOST_MORE_VALUE 2
#define REVMOB_POPUP_VALUE 3
#define REVMOB_FULLSCREEN_VALUE 4
#define MOBCLIX_VALUE 5


@synthesize adView;
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
    
    if (adView) {
        // We only want one ad at a time
        [self cancelAd];
    }
    
    adCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 50.0f)] autorelease];
        //adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)] autorelease];

       // adView setGestu
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(300, 40, 16, 17)];
        
    }
    else
    {
        //adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(25, 0, 728, 90.0f)] autorelease];
      
        adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(25, 0, 728, 90.0f)] autorelease];
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton-ipad.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(720, 70, 40, 41)];        
    }
    
    
    
    UIViewController* mobVC=[[UIViewController alloc] init] ;
    [mobVC setView: adView];
    [[[CCDirector sharedDirector] openGLView] addSubview:mobVC.view];
    //[[[CCDirector sharedDirector] openGLView] bringSubviewToFront:adView];
    //mobVC.view bringSubviewToFront:<#(UIView *)#>
    //[self presentViewController:mobVC];
    //[[[CCDirector sharedDirector] openGLView] addSubview:adView];
    
    [adCloseButton addTarget:self action:@selector(purchaseAdNew) forControlEvents:UIControlEventTouchUpInside];
    
     [[[CCDirector sharedDirector] openGLView] addSubview:adCloseButton];
    
    if (![[InAppPurchaseManager sharedInAppManager]  storeLoaded])
        [adCloseButton setHidden:TRUE];
    
    
    [self.adView resumeAdAutoRefresh];
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
    
    [self.adView cancelAd];
	self.adView.delegate = nil;
	self.adView = nil;
    
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
    [self.adView pauseAdAutoRefresh];
    [self.adView setHidden:YES];
    [adCloseButton setHidden:YES];
    [Flurry logEvent:@"Removed Banner Ads"];
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
    
    [self.adView resumeAdAutoRefresh];
    
    [self.adView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [self.adView setClipsToBounds:TRUE];
    
    [self.adView setHidden:NO];
    [adCloseButton setHidden:NO];
}



-(void) hideBannerAd {
    [self.adView pauseAdAutoRefresh];
    [self.adView setHidden:YES];
    [adCloseButton setHidden:YES];
}

-(void) cancelAd {
    // Can only cancel it if it exists
    if (adView) {
        [adView cancelAd];
        [adView setDelegate:nil];
        [adView removeFromSuperview];
        adView = nil;
        
        [adCloseButton removeFromSuperview];
        adCloseButton = nil;
    }
}
-(void) start {
    
    
}

-(void) startMobclix {

    if (!adStarted)
        adStarted = YES;
    [Mobclix startWithApplicationId:MOBCLIX_ID];
}

-(void) startRevMobAds{
    [RevMobAds startSessionWithAppID:REVMOBADS_ID];
}

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}


-(void)tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");	
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

-(void) startTapJoyConnect{
    [TapjoyConnect requestTapjoyConnect:TAPJOY_APP_ID secretKey:TAPJOY_SECRET_KEY];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
    
    [TapjoyConnect setTransitionEffect:TJCTransitionExpand];
	[TapjoyConnect setUserdefinedColorWithIntValue:0x808080];
}

-(void) startChartBoost{
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = CHARTBOOST_ID;
    cb.appSignature = CHARTBOOST_APP_SIGNATURE;
    [cb startSession];
    [cb cacheInterstitial];
    [cb cacheMoreApps];
    
}

-(void) showChartBoost{
    // Show an interstitial

    
    Chartboost *cb = [Chartboost sharedChartboost];
    if ([cb hasCachedInterstitial]);
        [cb showInterstitial];
}

-(void) showChartBoostMore{
    // Show an interstitial
    Chartboost *cb = [Chartboost sharedChartboost];
    //[cb cacheInterstitial];
    [cb showMoreApps];
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
    pushManager = [[PushNotificationManager alloc] initWithApplicationCode:@"25CA1-680B8" appName:@"The Harlem Dead" ];
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
        [Flurry logEvent:@"Showing Chartboost"];
    }
    else if (value == CHARTBOOST_MORE_VALUE)
     {
         [self showChartBoostMore];
         [Flurry logEvent:@"Showing ChartBoost More"];
     }
    else if(value == REVMOB_POPUP_VALUE) //RevMob
    {
        //[RevMobAds showPopupWithDelegate:self];
        
        [[RevMobAds session] showPopup];
        
        [Flurry logEvent:@"Showing Revmob Popup"];
    }
    else if(value == REVMOB_FULLSCREEN_VALUE) //RevMobFullScreen
    {
        [[RevMobAds session] showFullscreen];
        [Flurry logEvent:@"Showing Revmob Fullscreen"];
    }
}

-(void) clickFreeGameButton {
    if (isInReview == 0)
        return;
    
    [Flurry logEvent:@"HomeScene_FreeGameButton"];
    
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
