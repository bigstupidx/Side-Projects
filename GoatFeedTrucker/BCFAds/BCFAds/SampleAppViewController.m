#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
#import "SampleAppViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SampleAppViewController () {
    int yCoordinateControl;
}

@property (assign,nonatomic) bool statusBarVisibility;

- (UIImage *)imageWithColor:(UIColor *)color;
- (void)createButtonWithName:(NSString *)name andSelector:(SEL)selector;
- (void)addVerticalSpace;


@end

@implementation SampleAppViewController

@synthesize statusBarVisibility=_statusBarVisibility;

- (id)init {
    self = [super init];
    if (self) {
        yCoordinateControl = 10;
    }
    return self;
}

#pragma mark Layout methods

- (void)createButtonWithName:(NSString *)name andSelector:(SEL)selector {
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(10, yCoordinateControl, 300, 40)] autorelease];
    [button setTitle:name forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    UIImage *background1 = [self imageWithColor:[UIColor grayColor]];
    UIImage *background2 = [self imageWithColor:[UIColor lightGrayColor]];
    [button setBackgroundImage:background1 forState:UIControlStateNormal];
    [button setBackgroundImage:background2 forState:UIControlStateSelected];

    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;

    [self.view addSubview:button];
    yCoordinateControl += 50;
}

- (void)addVerticalSpace {
    yCoordinateControl += 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusBarVisibility = false;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = scroll;
    [scroll release];

    [self createButtonWithName:@"Start Session" andSelector:@selector(startSession)];
    [self createButtonWithName:@"Start Session (Testing with Ads)" andSelector:@selector(testingWithAds)];
    [self createButtonWithName:@"Start Session (Testing without Ads)" andSelector:@selector(testingWithoutAds)];
    [self addVerticalSpace];
    
    [self createButtonWithName:@"Show Fullscreen" andSelector:@selector(showFullscreen)];
    [self createButtonWithName:@"Show Fullscreen with delegate" andSelector:@selector(showFullscreenWithDelegate)];
    [self createButtonWithName:@"Show Fullscreen for orientations" andSelector:@selector(showFullscreenWithSpecificOrientations)];

    [self createButtonWithName:@"Load Fullscreen" andSelector:@selector(loadFullscreen)];
    [self createButtonWithName:@"Release Fullscreen" andSelector:@selector(releaseFullscreen)];
    [self addVerticalSpace];
    
    [self createButtonWithName:@"Show Banner (Default)" andSelector:@selector(showBanner)];
    [self createButtonWithName:@"Banner with custom frame" andSelector:@selector(showBannerWithCustomFrame)];
    [self createButtonWithName:@"Banner for orientations" andSelector:@selector(showBannerWithSpecificOrientations)];
    [self createButtonWithName:@"Hide Banner" andSelector:@selector(hideBanner)];
    [self createButtonWithName:@"Deactivate Banner" andSelector:@selector(deactivateBanner)];
    [self addVerticalSpace];

    {
        CGRect frame = CGRectMake(10, yCoordinateControl, 300, 40);
        UIButton *button = [RevMobAds buttonAdWithDelegate:self withFrame:frame];
        [self.view addSubview:button];
        [button setTitle:@"Free Games" forState:UIControlStateNormal];
        yCoordinateControl += 50;
    }
    
    [self addVerticalSpace];
    
    [self createButtonWithName:@"Open Ad Link" andSelector:@selector(openAdLink)];
    [self addVerticalSpace];
    
    [self createButtonWithName:@"Show Popup" andSelector:@selector(showPopup)];
    [self addVerticalSpace];
    
    [self createButtonWithName:@"Print Env Info" andSelector:@selector(printEnvironmentInformation)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    scroll.contentSize = CGSizeMake(320,yCoordinateControl);

//    To test RevMobBannerView
//    RevMobAds *revmob = [[RevMobAds alloc] initWithAppId:REVMOB_ID delagate:nil];
//    RevMobBannerView *banner = [[revmob bannerView] retain];
//    [banner loadAd];
//    banner.delegate = self;
//    banner.frame = CGRectMake(0, 0, 300, 20);
//    banner.backgroundColor = [UIColor redColor];
//    [self.view addSubview:banner];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Test with all orientations
    return YES;
    
    // Test only with Portrait mode
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    
    // Test only with Landscape mode
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark Methods to test RevMob Ads

- (void)startSession {
    [RevMobAds startSessionWithAppID:REVMOB_ID testingMode:RevMobAdsTestingModeOff];
}

- (void)testingWithAds {
    [RevMobAds startSessionWithAppID:REVMOB_ID testingMode:RevMobAdsTestingModeWithAds];
}

- (void)testingWithoutAds {
    [RevMobAds startSessionWithAppID:REVMOB_ID testingMode:RevMobAdsTestingModeWithoutAds];
}

- (void)showFullscreen {
//    RevMobAds *revmob = [RevMobAds revMobAds];
//    [revmob showFullscreen];
    [RevMobAds showFullscreenAd];
}

- (void)showFullscreenWithDelegate {
    [RevMobAds showFullscreenAdWithDelegate:self];
}

- (void)showFullscreenWithSpecificOrientations {
    [RevMobAds showFullscreenAdWithDelegate:self
                   withSpecificOrientations:UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationLandscapeLeft, nil];

}

- (void)loadFullscreen {
    [RevMobAds loadFullscreenAd];
}

- (void)isLoadedFullscreen {
    NSLog(@"[RevMob Sample App] loaded = %i", [RevMobAds isLoadedFullscreenAd]);
}

- (void)releaseFullscreen {
    [RevMobAds releaseFullscreenAd];
}

- (void)showBanner {
//    RevMobAds *revmob = [RevMobAds revMobAds];
//    [revmob showBanner];
    [RevMobAds showBannerAdWithDelegate:self];
}

- (void)showBannerWithCustomFrame {
    [RevMobAds showBannerAdWithFrame:CGRectMake(10, 20, 200, 40) withDelegate:self];
}

- (void)showBannerWithSpecificOrientations {
    [RevMobAds showBannerAdWithDelegate:self withSpecificOrientations:UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationLandscapeLeft, nil];
}

- (void)hideBanner {
//    RevMobAds *revmob = [RevMobAds revMobAds];
//    [revmob hideBanner];
    [RevMobAds hideBannerAd];
}

- (void)deactivateBanner {
    [RevMobAds deactivateBannerAd];
}

- (void)openAdLink {
    RevMobAds *revmob = [RevMobAds revMobAds];
    [revmob openAdLinkWithDelegate:self];
}

- (void)showPopup {
    RevMobAds *revmob = [RevMobAds revMobAds];
    [revmob showPopup];
}

- (void)printEnvironmentInformation {
    [RevMobAds printEnvironmentInformationWithAppID:REVMOB_ID];
}

#pragma mark RevMobAdsDelegate methods

- (void)revmobAdDidReceive {
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);
}

- (void)revmobAdDisplayed {
    NSLog(@"[RevMob Sample App] Ad displayed.");
}

- (void)revmobUserClosedTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the close button.");
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the Ad.");
}

- (void)installDidReceive {
    NSLog(@"[RevMob Sample App] Install did receive.");
}

- (void)installDidFail {
    NSLog(@"[RevMob Sample App] Install did fail.");
}

#pragma mark Others

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)dealloc {
    [super dealloc];
}

@end
