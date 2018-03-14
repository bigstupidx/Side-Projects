//
//  GoftwareAppDelegate.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 10/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Preferences.h"
#import "PageMainViewController.h"
#import "TMXUtility.h"
#import "DataUtility.h"
#import "Avatar.h"
#import "Item.h"
#import "Hit.h"
#import "Fire.h"
#import "Level.h"
#import "Avatar.h"
#import "Fire.h"
#import "Hit.h"
#import "SoundManager.h"
//#import "TestFlight.h"
#import "RevMobAds/RevMobAds.h"
#import "TapjoyConnect.h"
#import "PushNotificationManager.h"

@class EAGLView;

@interface GoftwareAppDelegate : NSObject <UIApplicationDelegate,RevMobAdsDelegate,PushNotificationDelegate,TJCAdDelegate, TJCVideoAdDelegate>
{
	UIWindow *window;
	
	PageMainViewController *_pageMainViewController;
    
    PushNotificationManager *pushManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) PushNotificationManager *pushManager;

-(void) onInitialize;
-(void) handlePushRegistration:(NSData *)deviceToken;
-(void) handlePushReceived:(NSDictionary *)userInfo;

@end

