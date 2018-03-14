//
//  PageMainViewController.h
//  iEngine
//
//  Created by Muhammed Safiul Azam on 9/14/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Preferences.h"
#import "Page.h"
#import "PageTransition.h"
#import "PageOrientation.h"
#import "PageBaseViewController.h"
#import "PageLogoViewController.h"
#import "PagePlayViewController.h"
#import "PageMenuViewController.h"
#import "PageHighscoreViewController.h"
#import "PageMarketViewController.h"
#import "PageInAppPurchaseViewController.h"
#import "PageLoadViewController.h"
#import "GADBannerView.h"
#import <iAd/iAd.h>
#import "LogUtility.h"

@interface PageMainViewController : PageBaseViewController<ADBannerViewDelegate, GADBannerViewDelegate> {

	Page _currentPage;
	Page _previousPage;
	
	PageBaseViewController *_currentPageViewController;
	PageBaseViewController *_previousPageViewController;
	
	PageOrientation _currentPageOrientation;
	PageOrientation _previousPageOrientation;
	
	IBOutlet UIView *_adView;
	IBOutlet UIView *_pageView;
	CGRect _pageFrame;
	
	GADBannerView *_gadBannerView;
	IBOutlet ADBannerView *_adBannerView;
}

-(PageOrientation) getCurrentPageOrientation;
-(void) setCurrentPageOrientation:(PageOrientation) orientation;

-(PageOrientation) getPreviousPageOrientation;
-(void) setPreviousPageOrientation:(PageOrientation) orientation;

-(void) changeOrientation:(PageOrientation) orientation;

-(Page) getCurrentPage;
-(void) setCurrentPage:(Page) page;

-(Page) getPreviousPage;
-(void) setPreviousPage:(Page) page;

-(PageBaseViewController *) getCurrentPageViewController;
-(void) setCurrentPageViewController:(PageBaseViewController *) viewController;

-(PageBaseViewController *) getPreviousPageViewController;
-(void) setPreviousPageViewController:(PageBaseViewController *) viewController;

-(void) gotoPage:(Page) page  parameters:(id) parameters;
-(void) gotoPage:(Page) page;

@end
