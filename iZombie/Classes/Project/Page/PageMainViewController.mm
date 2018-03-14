//
//  PageMainViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 9/14/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "PageMainViewController.h"


@implementation PageMainViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  
	[super viewDidLoad];
	
	_adView.hidden = YES;
	//_adBannerView.delegate = self;
    _gadBannerView = nil;
    
    // Avoid iAD.
	[_adBannerView removeFromSuperview];
	[self bannerView:nil didFailToReceiveAdWithError:nil];
	
	_pageFrame = _pageView.frame;
	
	[self setCurrentPageOrientation:PageOrientationLandscapeRight];
	[self setPreviousPageOrientation:PageOrientationLandscapeRight];
	
	[self setCurrentPage:PageNone];
	[self setPreviousPage:PageNone];
	
	[self setCurrentPageViewController:nil];
	[self setPreviousPageViewController:nil];
		
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(changeToPortraitOrientation:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

-(PageOrientation) getCurrentPageOrientation {
	
	return _currentPageOrientation;
}

-(void) setCurrentPageOrientation:(PageOrientation) orientation {
	
	_currentPageOrientation = orientation;
}

-(PageOrientation) getPreviousPageOrientation {
	
	return _previousPageOrientation;
}

-(void) setPreviousPageOrientation:(PageOrientation) orientation {
	
	_previousPageOrientation = orientation;
}

-(void) changeOrientation:(PageOrientation) orientation {
	
	[self setPreviousPageOrientation:[self getCurrentPageOrientation]];
	
	CGRect frame = [[UIScreen mainScreen] bounds];	
	
	if(orientation == PageOrientationLandscapeLeft) {
		
		self.view.bounds = CGRectMake(0, 0, frame.size.height, frame.size.width);
		self.view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
		[self.view setNeedsLayout];
		[self setRotate:270];
	}
	else if(orientation == PageOrientationLandscapeRight) {
		
		self.view.bounds = CGRectMake(0, 0, frame.size.height, frame.size.width);
		self.view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
		[self.view setNeedsLayout];
		[self setRotate:90];
	}
	else {
		
		self.view.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
		self.view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
		[self.view setNeedsLayout];
		[self setRotate:360];
	}
	
	// Ad view.
	CGRect pageFrame = _pageView.frame;
	CGFloat extraHeight = _adView.hidden ? _adView.frame.size.height : 0;
	pageFrame = CGRectMake(pageFrame.origin.x, pageFrame.origin.y, pageFrame.size.width, _pageFrame.size.height + extraHeight);
	_pageView.frame = pageFrame;
	// ...
	
	[self setCurrentPageOrientation:orientation];
	
	// Only for device.
	// It helps to rotate alerts according to orientation.
#if !(TARGET_IPHONE_SIMULATOR)
	if([self getCurrentPageOrientation] == PageOrientationLandscapeLeft)
		[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeLeft;
	else if([self getCurrentPageOrientation] == PageOrientationLandscapeRight)
		[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
	else
		[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
#endif
	
	NSLog(@"Rotate: %f", [self getRotate]);
}

-(void) changeInterfaceOrientation: (UIInterfaceOrientation) orientation {
	
	if([self getCurrentPage] == PageNone)
		return;
	
	[self willRotateToInterfaceOrientation:orientation duration:0.0];
	
	[UIView beginAnimations:@"" context:nil];
	[UIView setAnimationsEnabled:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:[(NSNumber *) [[Preferences getInstance] getValue:KEY_ANIMATION_TIME_MEDIUM] floatValue]];
	[UIView setAnimationDidStopSelector:@selector(changeInterfaceOrientationAnimationDidStop:finished:context:)];
	
	if(orientation == UIInterfaceOrientationLandscapeLeft)
		[self changeOrientation:PageOrientationLandscapeLeft];
	else if(orientation == UIInterfaceOrientationLandscapeRight)
		[self changeOrientation:PageOrientationLandscapeRight];
	else
		[self changeOrientation:PageOrientationPortrait];
	
	[UIView commitAnimations];
	
	NSLog(@"Change Orientation: %d", (NSInteger) orientation);
}

-(void) changeInterfaceOrientationAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	
	[self didRotateFromInterfaceOrientation:(UIInterfaceOrientation) orientation];
}

-(void) changeToPortraitOrientation: (NSNotification*) notification {
	
	if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
		[self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	// Uncomment to enable autorotate.
	/*if((interfaceOrientation == UIInterfaceOrientationPortrait && [self getCurrentPageOrientation] != PageOrientationPortrait)
	   || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft && [self getCurrentPageOrientation] != PageOrientationLandscapeLeft)
		|| (interfaceOrientation == UIInterfaceOrientationLandscapeRight && [self getCurrentPageOrientation] != PageOrientationLandscapeRight))
			[self changeInterfaceOrientation:interfaceOrientation];*/
		
	// Return YES for supported orientations
	return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Notifies when rotation begins, reaches halfway point and ends.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[[self getCurrentPageViewController] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	NSLog(@"WillRotateToInterfaceOrientation.");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	[[self getCurrentPageViewController] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	NSLog(@"DidRotateFromInterfaceOrientation.");
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(Page) getCurrentPage {
	
	return _currentPage;
}

-(void) setCurrentPage:(Page) page {
	
	_currentPage = page;
}

-(Page) getPreviousPage {
	
	return _previousPage;
}

-(void) setPreviousPage:(Page) page {
	
	_previousPage = page;
}

-(PageBaseViewController *) getCurrentPageViewController {
	
	return _currentPageViewController;
}

-(void) setCurrentPageViewController:(PageBaseViewController *) viewController {
	
	_currentPageViewController = viewController;
}

-(PageBaseViewController *) getPreviousPageViewController {
	
	return _previousPageViewController;
}

-(void) setPreviousPageViewController:(PageBaseViewController *) viewController {
	
	_previousPageViewController = viewController;
}

-(void) gotoPage:(Page) page  parameters:(id) parameters {
	
	[self setPreviousPage:[self getCurrentPage]];	
	[self setPreviousPageViewController:[self getCurrentPageViewController]];
	
	PageBaseViewController *pageBaseViewController = nil;
		
	switch (page) {
			
		case PageLogo:
			pageBaseViewController = [[PageLogoViewController alloc] initWithNibName:@"Page_Logo" bundle:[NSBundle mainBundle] parent:self];
			break;
        case PageMenu:
			pageBaseViewController = [[PageMenuViewController alloc] initWithNibName:@"Page_Menu" bundle:[NSBundle mainBundle] parent:self];
			break;
		case PagePlay:
			pageBaseViewController = [[PagePlayViewController alloc] initWithNibName:@"Page_Play" bundle:[NSBundle mainBundle] parent:self];
			break;	
        case PageHighscore:
			pageBaseViewController = [[PageHighscoreViewController alloc] initWithNibName:@"Page_Highscore" bundle:[NSBundle mainBundle] parent:self];
			break;	
        case PageMarket:
			pageBaseViewController = [[PageMarketViewController alloc] initWithNibName:@"Page_Market" bundle:[NSBundle mainBundle] parent:self];
			break;	
        case PageLoad:
			pageBaseViewController = [[PageLoadViewController alloc] initWithNibName:@"Page_Load" bundle:[NSBundle mainBundle] parent:self];
			break;
            
        case PageInAppPurchase:
			pageBaseViewController = [[PageInAppPurchaseViewController alloc] initWithNibName:@"PageInAppPurchaseViewController" bundle:[NSBundle mainBundle] parent:self];
			break;
            
			break;
            
		default:
			break;
	}
	
	PageOrientation currentOrientation = [self getCurrentPageOrientation];
	PageOrientation previousOrientation = [self getPreviousPageOrientation];
	
	[self changeOrientation:PageOrientationPortrait];
	[_pageView addSubview:pageBaseViewController.view];		
	
	[self changeOrientation:currentOrientation];
	[self setPreviousPageOrientation:previousOrientation];
				
	CGFloat animationTime = [(NSNumber *) [[Preferences getInstance] getValue:KEY_ANIMATION_TIME_MEDIUM] floatValue];
		
	if([self getPreviousPage] != PageNone) {
		
		pageBaseViewController.view.userInteractionEnabled = NO;
		
		if(parameters != nil)
			if([(NSNumber *) parameters intValue] != PageTransitionNone) {
				
				if([(NSNumber *) parameters intValue] == PageTransitionSlideLeft) {
					[pageBaseViewController.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
					[pageBaseViewController.view setCenter:CGPointMake(self.view.bounds.size.width / 2 + self.view.bounds.size.width, self.view.bounds.size.height / 2)];
				}
				else if([(NSNumber *) parameters intValue] == PageTransitionSlideRight) {
					[pageBaseViewController.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
					[pageBaseViewController.view setCenter:CGPointMake(-(self.view.bounds.size.width / 2 + self.view.bounds.size.width), self.view.bounds.size.height / 2)];
				}
				else if([(NSNumber *) parameters intValue] == PageTransitionFadeIn) {
					
					pageBaseViewController.view.alpha = 0.0;
					[pageBaseViewController.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
					[pageBaseViewController.view setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
				}
				else if([(NSNumber *) parameters intValue] == PageTransitionFadeOut) {
					
					pageBaseViewController.view.alpha = 1.0;
					[pageBaseViewController.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
					[pageBaseViewController.view setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
				}
				else {
					
					pageBaseViewController.view.hidden = YES;
					[pageBaseViewController.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
					[pageBaseViewController.view setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
				}
				
				if([(NSNumber *) parameters intValue] == PageTransitionCurlUp 
				   || [(NSNumber *) parameters intValue] == PageTransitionCurlDown)
					animationTime = [(NSNumber *) [[Preferences getInstance] getValue:KEY_ANIMATION_TIME_LONG] floatValue];
			}
			
		[self getCurrentPageViewController].view.userInteractionEnabled = NO;
	}
	
	[pageBaseViewController.view setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
		
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationsEnabled:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:animationTime];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationDidStopSelector:@selector(gotoAnimationDidStop:finished:context:)];
	
	if(parameters != nil)
		if([(NSNumber *) parameters intValue] != PageTransitionNone) {
	
			if([(NSNumber *) parameters intValue] == PageTransitionFlipLeft) {
		
				[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
				pageBaseViewController.view.hidden = NO;
			}
			else if([(NSNumber *) parameters intValue] == PageTransitionFlipRight) {
		
				[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
				pageBaseViewController.view.hidden = NO;
			}
			else if([(NSNumber *) parameters intValue] == PageTransitionCurlUp) {
		
				[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
				pageBaseViewController.view.hidden = NO;
			}
			else if([(NSNumber *) parameters intValue] == PageTransitionCurlDown) {
		
				[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
				pageBaseViewController.view.hidden = NO;
			}
			else if([(NSNumber *) parameters intValue] == PageTransitionFadeIn) {
				
				pageBaseViewController.view.alpha = 1.0;
			}
			else if([(NSNumber *) parameters intValue] == PageTransitionFadeOut) {
				
				pageBaseViewController.view.alpha = 0.0;
			}
			
		}
		
	[UIView commitAnimations];
		
	[self setCurrentPageViewController:pageBaseViewController];		
	[self setCurrentPage:page];
}

-(void) gotoAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
		
	[self getCurrentPageViewController].view.userInteractionEnabled = YES;
		
	if([self getPreviousPageViewController] != nil) {
	
        PageBaseViewController *pageBaseViewController = [self getPreviousPageViewController];
        [pageBaseViewController.view removeFromSuperview];
        [pageBaseViewController release];
        [self setPreviousPageViewController:nil];
	}
	
	NSLog(@"Goto Animation Did Stop.");
}

-(void) gotoPage:(Page) page {
	
	[self gotoPage:page parameters:nil];
}

- (void)bannerViewDidLoadAd:(ADBannerView *) banner
{
    [_adView bringSubviewToFront:_adBannerView];
	
	if(_gadBannerView != nil)
	{
		_gadBannerView.delegate = nil;
		[_gadBannerView removeFromSuperview];
		[_gadBannerView release];
		_gadBannerView = nil;
	}
	
	if(_adView.hidden)
	{
		_adView.hidden = NO;
		[self changeOrientation:[self getCurrentPageOrientation]];
	}
	
	NSLog(@"bannerViewDidLoadAd");
}

- (void)bannerView:(ADBannerView *) banner didFailToReceiveAdWithError:(NSError *)error
{	
	if(_adView.hidden)
	{
        // Avoid AdMob.
		/*if(_gadBannerView == nil)
		{
			_gadBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
			_gadBannerView.adUnitID = ADMOB_PUBLISHER_ID;
			_gadBannerView.delegate = self;
			_gadBannerView.rootViewController = self;
			[_adView addSubview:_gadBannerView];
			[_gadBannerView loadRequest:[GADRequest request]];
		}*/
	}
	
	NSLog(@"didFailToReceiveAdWithError");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave 
{
	return YES;
}

// GAD.
- (void)adViewDidReceiveAd:(GADBannerView *) view 
{
	[_adView bringSubviewToFront:_gadBannerView]; 
	
	if(_adView.hidden)
	{
		_adView.hidden = NO;
		[self changeOrientation:[self getCurrentPageOrientation]];
	}
	
	NSLog(@"adViewDidReceiveAd");
}

- (void)adView:(GADBannerView *) view didFailToReceiveAdWithError:(GADRequestError *) error
{
	NSLog(@"didFailToReceiveAdWithError");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
	
}
// ...

- (void)dealloc {
	
	_adBannerView.delegate = nil;
	
	if(_gadBannerView != nil)
	{
		_gadBannerView.delegate = nil;
		[_gadBannerView removeFromSuperview];
		[_gadBannerView release];
		_gadBannerView = nil;
	}
	
	[[LogUtility getInstance] printMessage:@"PageMainViewController - dealloc"];
    	
	[super dealloc];
}


@end
