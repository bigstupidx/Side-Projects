//
//  AdsManager.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-12.
//  Copyright 2012 NetMatch. All rights reserved.
//

#import "AdsManager.h"
#import "Mobclix.h"

#import "FlurryAnalytics.h"
#import "ChartBoost.h"
#import "InAppPurchaseManager.h"
#import "Reachability.h"


@implementation AdsManager

#define TAPJOY_APP_ID @"c67d7b09-7991-40c2-b5e2-e26dec6b6a56"
#define TAPJOY_SECRET_KEY @"fkunmt1Yd7VtnG3VX6MW"

#define CHARTBOOST_ID @"4fe92995f776598403000000"
#define CHARTBOOST_APP_SIGNATURE @"3fa7f600235e0a93948fc3d8698670733b27489d"

#define MOBCLIX_ID @"B107FE18-421B-44FA-9AA6-36DD1FEA2E56 "

#define REVMOBADS_ID @"5023280120b0770c0000001e"

#define PLIST_URL @"http://iosgames.slightlysocial.com/lsadsettings.plist"


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
    [FlurryAnalytics logEvent:@"Removed Banner Ads"];
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
    //[RevMobAds showPopupWithDelegate:nil];
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
}

-(void) showChartBoost{
    // Show an interstitial
    Chartboost *cb = [Chartboost sharedChartboost];
    //[cb cacheInterstitial];
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
        [FlurryAnalytics logEvent:@"Showing Chartboost"];
    }
    else if (value == CHARTBOOST_MORE_VALUE)
     {
         [self showChartBoostMore];
         [FlurryAnalytics logEvent:@"Showing ChartBoost More"];
     }
    else if(value == REVMOB_POPUP_VALUE) //RevMob
    {
        [RevMobAds showPopup];
        [FlurryAnalytics logEvent:@"Showing Revmob Popup"];
    }
    else if(value == REVMOB_FULLSCREEN_VALUE) //RevMobFullScreen
    {
        [RevMobAds showFullscreenAd];
        [FlurryAnalytics logEvent:@"Showing Revmob Fullscreen"];
    }
}

-(void) clickFreeGameButton {
    if (isInReview == 0)
        return;
    
    [FlurryAnalytics logEvent:@"HomeScene_FreeGameButton"];
    
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
