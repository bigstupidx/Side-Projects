//
//  RootViewController.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-06.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "Globals.h"
#import "RootViewController.h"
#import "FlurryAnalytics.h"
#import "SpaceRaceIAPHelper.h"
#import "Reachability.h"

#import "MobclixAds.h"
#import "TapjoyConnect.h"
#import "GameKitLibrary.h"

@implementation RootViewController

@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //UIImage *bgImage;
    
    //tempVC=[[UIViewController alloc] init] ;
    
    //self.adView = [[[MobclixAdViewiPhone_320x50
    
     //if(![Util isAdsRemoved] && [Util isMobclixBannerAdEnabled])
     //{
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
             self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];
         else
             self.adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.0f, 90.0f)] autorelease];
         
         [self.view addSubview:self.adView];
     //}
    
    //add the remove ads button
    adCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(300, 50, 16, 17)];
    }
    else
    {
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton-ipad.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(720, 40, 40, 41)];        
    }
    
    [self.view addSubview:adCloseButton];
    
    /*
    bool isPauseScreen = FALSE;
    if(isPauseScreen)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            bgImage = [UIImage imageNamed:@"pausebg.png"];
        else
            bgImage = [UIImage imageNamed:@"pausebg-ipad.png"];
        
        if(![Util isInReview])
        {
            
            if([Util getAutoFeaturedAdPauseScreen] == 3) //NoAds
            {
                //return;
            }
            
            if([Util isChartboostFeaturedAdEnabled] && [Util getAutoFeaturedAdPauseScreen] == 0) //Chartboost
                [self getChartBoostFeaturedAd];
            
            if([Util isRevMobFeaturedAdEnabled] && [Util getAutoFeaturedAdPauseScreen] == 1) //RevMob
                [RevMobAds showPopupWithAppID:@"4fe92b1ff286c900080000b2 " withDelegate:nil];
            
            if([Util isTapJoyFeaturedAdEnabled] && [Util getAutoFeaturedAdPauseScreen] == 2) //Tapjoy
                [TapjoyConnect getFeaturedApp];
            
            if([Util isRevMobFeaturedAdEnabled] && [Util getAutoFeaturedAdPauseScreen] == 4) //RevMobFullScreen
                [RevMobAds showFullscreenAdWithAppID:@"4fe92b1ff286c900080000b2 " withDelegate:nil];
        }
        
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            bgImage = [UIImage imageNamed:@"mainscreen.png"];
        else
            bgImage = [UIImage imageNamed:@"mainscreen-ipad.png"];
        
        
        if(![Util isInReview])
        {
            if([Util getAutoFeaturedAdSplashScreen] == 3) //NoAds
            {   
                //return;
            }
            
            if([Util isChartboostFeaturedAdEnabled] && [Util getAutoFeaturedAdSplashScreen] == 0) //Chartboost
                [self getChartBoostFeaturedAd];
            
            if([Util isRevMobFeaturedAdEnabled] && [Util getAutoFeaturedAdSplashScreen] == 1) //RevMob
                [RevMobAds showPopupWithAppID:@"4fe92b1ff286c900080000b2 " withDelegate:nil];
            
            if([Util isTapJoyFeaturedAdEnabled] && [Util getAutoFeaturedAdSplashScreen] == 2) //Tapjoy
                [TapjoyConnect getFeaturedApp];
            
            if([Util isRevMobFeaturedAdEnabled] && [Util getAutoFeaturedAdSplashScreen] == 4) //RevMobFullScreen
                [RevMobAds showFullscreenAdWithAppID:@"4fe92b1ff286c900080000b2 " withDelegate:nil];
            
        }
    }
    
    
    
    /*UIImageView *bgViewTemp = [[UIImageView alloc] initWithImage:bgImage];
	[self.view insertSubview:bgViewTemp atIndex:0];
    
    
    
    
    if(![Util isAdsRemoved] && [Util isMobclixBannerAdEnabled])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];
        else
            self.adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.0f, 90.0f)] autorelease];
        
        [self.view addSubview:self.adView];
    }
    if(![Util isAdsRemoved] && [Util isTapJoyBannerAdEnabled])
    {
        [TapjoyConnect getDisplayAdWithDelegate:self];
    }
    
    adCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    restoreIAPButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(300, 50, 16, 17)];
        
        [restoreIAPButton setBackgroundImage:[[UIImage imageNamed:@"restore.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [restoreIAPButton setFrame:CGRectMake(2, 150, 84, 37)];
        
    }
    else
    {
        [adCloseButton setBackgroundImage:[[UIImage imageNamed:@"adexitbutton-ipad.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [adCloseButton setFrame:CGRectMake(720, 40, 40, 41)];        
        
        [restoreIAPButton setBackgroundImage:[[UIImage imageNamed:@"restore-ipad.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [restoreIAPButton setFrame:CGRectMake(4, 310, 202, 90)];        
        
    }
    
    [adCloseButton addTarget:self action:@selector(adCloseButtonCallback) forControlEvents:UIControlEventTouchUpInside];
    [restoreIAPButton addTarget:self action:@selector(restoreButtonCallback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restoreIAPButton];
    
    if(![Util isAdsRemoved])
        [self.view addSubview:adCloseButton];*/
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return FALSE;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.adView resumeAdAutoRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.adView pauseAdAutoRefresh];
}

- (void) adCloseButtonCallback
{
    //NSLog(@"adCloseButtonCallback");
    [self purchaseAdRemovalCallback];
}

- (void) purchaseAdRemovalCallback
{
    
    [FlurryAnalytics logEvent:@"HomeScreen_IAPButton_Clicked"];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
 	
	Reachability *reach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [reach currentReachabilityStatus];    
	if (netStatus == NotReachable) {        
		NSLog(@"No internet connection!");        
	} else {        
		if ([SpaceRaceIAPHelper sharedHelper].products == nil) {
			
			[[SpaceRaceIAPHelper sharedHelper] requestProducts];
			//			self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
			//			_hud.labelText = @"Loading...";
			[self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
			
		}
		else {
			[self buyProduct];
		}
        
	}
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

- (void) saveAdRemovalStatus
{
    if(![Util isAdsRemoved] && [Util isTapJoyBannerAdEnabled])
    {
        [[TapjoyConnect getDisplayAdView] removeFromSuperview];
        [TapjoyConnect getDisplayAdWithDelegate:nil];
    }
    
    if(![Util isAdsRemoved] && [Util isMobclixBannerAdEnabled])
    {
        [self.adView cancelAd];
        self.adView.delegate = nil;
        [self.adView removeFromSuperview];
        self.adView = nil;
    }
    if(![Util isAdsRemoved])
        [adCloseButton removeFromSuperview];
    
    //[myCreator removeCurrentBannerAd];
	[Util setAdsRemoved:YES];
}

- (void) setAdViewHidden: (BOOL) value{
    [adView setHidden:value];
    [adCloseButton setHidden:value];
    
}

- (void) buyProduct {
    
    NSLog(@"buyProduct 0");
    
    if([[SpaceRaceIAPHelper sharedHelper].products count] == 0)
        return;
    
    SKProduct *product = [[SpaceRaceIAPHelper sharedHelper].products objectAtIndex:0]; // only 1 product in my list
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[SpaceRaceIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    
	//    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	//    _hud.labelText = @"Buying comic...";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    
}

- (void) getMoreGamesCallback
{
    if([Util isTapJoyOfferWallEnabled])
        [TapjoyConnect showOffers];
    
    if([Util isChartboostOfferWallEnabled])
        [self getChartBoostMoreAds];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    SpaceBubbleViewController *spaceBubbleViewController = [[[SpaceBubbleViewController alloc] init] autorelease];
    //    [self.navigationController pushViewController:spaceBubbleViewController animated:YES];
	[self dismiss];
}

- (void)dismiss {	
    [[TapjoyConnect getDisplayAdView] removeFromSuperview];
    [TapjoyConnect getDisplayAdWithDelegate:nil];
    
    //controller.gamePaused = NO;
    
    [self.view removeFromSuperview];
	[self release];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

//TapJoy Implementation

// This method is called after Ad data has been successfully received from the server. 
- (void)didReceiveAd:(TJCAdView*)TJCadView
{
	[self.view addSubview:TJCadView];
	[TJCadView setCenter:CGPointMake(160, 25)];
}

// This method is called if an error has occurred while requesting Ad data. 
- (void)didFailWithMessage:(NSString*)msg
{
    //    adView.hidden = YES;
	NSLog(@"TapJoy Error: %@", msg);
}

// This method must return one of TJC_AD_BANNERSIZE_320X50, TJC_AD_BANNERSIZE_640X100, or TJC_AD_BANNERSIZE_768X90. 
- (NSString*)adContentSize
{
	return TJC_AD_BANNERSIZE_320X50;
}

// This method must return a boolean indicating whether the Ad will automatically refresh itself.
- (BOOL)shouldRefreshAd
{
	return NO;
    //    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
    [self.adView cancelAd];
	self.adView.delegate = nil;
	self.adView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [self.adView cancelAd];
	self.adView.delegate = nil;
	self.adView = nil;
    
    //deallocCalled = YES;
    [super dealloc];
}

@end
