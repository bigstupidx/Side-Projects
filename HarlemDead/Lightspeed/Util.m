// Util.m
//  ZombieBrains
//
//  Created by Obaid Saleem on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "Util.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Util

+ (BOOL)isPad
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (CGSize)screenSize
{
    
    //    return [[CCDirector sharedDirector] winSize];
    
	UIScreen *screen = [UIScreen mainScreen];
	CGFloat screenWidth = screen.bounds.size.width;
	CGFloat screenHeight = screen.bounds.size.height;
	
	return CGSizeMake(screenWidth, screenHeight);
    
}

+ (NSString *)getDeviceSpecificFileName:(NSString *)imageName
{
	NSString *filename;
	if([self isPad])
	{
		filename = [NSString stringWithFormat:@"%@-%@", imageName,@"ipad"];
		
	}
	else {
		filename = imageName;
	}
	//NSLog(filename);
	return filename;
    
}

+ (NSString *) getFormattedTime: (NSInteger) timeInSeconds
{
	int seconds, minutes, hours;
	
	seconds = timeInSeconds % 60;
	
	minutes = (timeInSeconds/60) % 60;
	
	hours = timeInSeconds/3600;
	
	NSString *hourString, *minuteString, *secondString;
	
	hourString = (hours > 9) ? [NSString stringWithFormat:@"%d", hours] : [NSString stringWithFormat:@"0%d", hours];
	minuteString = (minutes > 9) ? [NSString stringWithFormat:@"%d", minutes] : [NSString stringWithFormat:@"0%d", minutes];
	secondString = (seconds > 9) ? [NSString stringWithFormat:@"%d", seconds] : [NSString stringWithFormat:@"0%d", seconds];
	return [NSString stringWithFormat:@"%@:%@:%@", hourString, minuteString, secondString];
}

+ (void) playSound: (NSString *) soundName
{
	NSString *path = [NSString stringWithFormat:@"%@/%@",
					  [[NSBundle mainBundle] resourcePath],
					  soundName];
	
	//declare a system sound id
	SystemSoundID soundID;
	
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
	
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
	
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
}

+ (BOOL) isSoundFXOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"isSoundFXOn"];    
}

+ (BOOL) isMusicOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"isMusicOn"];    
}

+ (void) setSoundFXOn: (BOOL) onOff
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setBool:onOff forKey:@"isSoundFXOn"];
}

+ (void) setMusicOn: (BOOL) onOff
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setBool:onOff forKey:@"isMusicOn"];
}

+ (void) saveUnlockHeadsStatus: (BOOL)status
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"unlock6heads"];
}

+ (BOOL) loadUnlockHeadsStatus
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"unlock6heads"];
}

+ (void) savePostedToFacebookStatus: (BOOL)status
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"postedonfacebook"];
}

+ (BOOL) loadPostedToFacebookStatus
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"postedonfacebook"];
}

+ (void) saveAppRunCount: (int)count
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:count forKey:@"appruncount"];
}

+ (int) loadAppRunCount
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"appruncount"];
}

+ (void) saveIsRated: (BOOL)status
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"israted"];
}

+ (BOOL) loadIsRated
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"israted"];
}

+ (void) saveFeaturedAppCount: (int)count
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:count forKey:@"featuredappruncount"];
}

+ (int) loadFeaturedAppCount
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"featuredappruncount"];
}

+ (void) saveFAEDLinkCount: (int)count
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:count forKey:@"faedlinkcount"];
    
}
+ (int) loadFAEDLinkCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"faedlinkcount"];    
}

+ (void) setRevMobFeaturedAdEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"revmobfeatured"];
}
+ (void) setRevMobOfferWallEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"revmobofferwall"];
}
+ (void) setTapJoyFeaturedAdEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"tapjoyfeatured"];
}
+ (void) setTapJoyOfferWallEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"tapjoyofferwall"];
}
+ (void) setTapJoyBannerAdEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"tapjoybanner"];
}
+ (void) setMobclixFeaturedAdEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"mobclixfeatured"];
}
+ (void) setMobclixOfferWallEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"mobclixofferwall"];
}
+ (void) setMobclixBannerAdEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"mobclixbanner"];
}

+ (void) setChartboostFeaturedAdEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"chartboostfeatured"];
}
+ (void) setChartboostOfferWallEnabled :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"chartboostofferwall"];
}
+ (void) setAdsRemoved :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"adsremoved"];
}

+ (BOOL) isRevMobFeaturedAdEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"revmobfeatured"];    
}
+ (BOOL) isRevMobOfferWallEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"revmobofferwall"];    
}

+ (BOOL) isTapJoyFeaturedAdEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"tapjoyfeatured"];    
}
+ (BOOL) isTapJoyOfferWallEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"tapjoyofferwall"];    
}
+ (BOOL) isTapJoyBannerAdEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"tapjoybanner"];    
}
+ (BOOL) isMobclixFeaturedAdEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"mobclixfeatured"];    
}
+ (BOOL) isMobclixOfferWallEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"mobclixofferwall"];    
}
+ (BOOL) isMobclixBannerAdEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"mobclixbanner"];    
}

+ (BOOL) isChartboostFeaturedAdEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"chartboostfeatured"];    
}
+ (BOOL) isChartboostOfferWallEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"chartboostofferwall"];    
}

+ (BOOL) isFlurryEnabled
{
    return YES;
}
+ (BOOL) isPushWooshEnabled
{
    return YES;
}

+ (BOOL) isAdsRemoved
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"adsremoved"];    
}

+ (NSString*) getFacebookPageLink
{
    return @"http://bit.ly/tinyspacerace";
    
}
+ (NSString*) getTwitterPageLink
{
    return @"http://bit.ly/tinyspacerace";
}

+ (NSDictionary *) loadConfigFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"config.plist"];
    
    return [[NSDictionary alloc]initWithContentsOfFile:plistPath];    
}

+ (void) saveConfigFile :(NSMutableData *) data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *plistFile = [documentsDirectory stringByAppendingPathComponent:@"config.plist"];
	
	[data writeToFile:plistFile atomically:YES];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (int) getAppBecomeActive
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"appbecomeactive"];    
}
+ (int) getFreeGamesSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"getfreegamessettings"];    
}
+ (int) getFreeGamesGameover
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"getfreegamesgameover"];    
}
+ (int) getBonusGameInstructions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"bonusgameinstructions"];    
}
+ (int) getBonusGameMain
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"bonusgamemain"];    
}

+ (void) setAppBecomeActive :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"appbecomeactive"];
}
+ (void) setFreeGamesSettings :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"getfreegamessettings"];
}
+ (void) setFreeGamesGameover :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"getfreegamesgameover"];
}
+ (void) setBonusGameMainService :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"bonusgamemain"];
}
+ (void) setBonusGameInstructions :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"bonusgameinstructions"];
}

+ (void) setFeaturedAdGameover :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"featuredadgameover"];
}
+ (int) getFeaturedAdGameover
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"featuredadgameover"];    
}

+ (void) setAutoFeaturedAdPauseScreen :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"autofeaturedadpausescreen"];
}
+ (int) getAutoFeaturedAdPauseScreen
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"autofeaturedadpausescreen"];    
}

+ (void) setAutoFeaturedAdSplashScreen :(int) service
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setInteger:service forKey:@"autofeaturedadsplashscreen"];
}
+ (int) getAutoFeaturedAdSplashScreen
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey:@"autofeaturedadsplashscreen"];    
}


+ (NSDictionary *) loadVersionFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"versions.plist"];
    
    return [[NSDictionary alloc]initWithContentsOfFile:plistPath];    
}

+ (void) saveVersionFile :(NSMutableData *) data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *plistFile = [documentsDirectory stringByAppendingPathComponent:@"versions.plist"];
	
	[data writeToFile:plistFile atomically:YES];
}

+ (float) getVersionNumberLatest
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults floatForKey:@"versionlive"];    
}

+ (void) setVersionNumberLatest :(float) versionNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setFloat:versionNumber forKey:@"versionlive"];
}

+ (float) getVersionNumberReview
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults floatForKey:@"versionreview"];    
}

+ (void) setVersionNumberReview :(float) versionNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setFloat:versionNumber forKey:@"versionreview"];
}

+ (void) setInReview :(BOOL) status
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:status forKey:@"isinreview"];
}
+ (BOOL) isInReview
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey:@"isinreview"];    
}

@end
