// Util.h
//  ZombieBrains
//
//  Created by Obaid Saleem on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface Util : NSObject {
    
}

+ (BOOL)isPad;
+ (CGSize)screenSize;
+ (NSString *)getDeviceSpecificFileName:(NSString *)imageName;
+ (NSString *) getFormattedTime: (NSInteger) timeInSeconds;
+ (void) playSound: (NSString *) soundName;

+ (BOOL) isMusicOn;
+ (BOOL) isSoundFXOn;
+ (void) setSoundFXOn: (BOOL) onOff;
+ (void) setMusicOn: (BOOL) onOff;
+ (void) saveUnlockHeadsStatus: (BOOL)status;
+ (BOOL) loadUnlockHeadsStatus;
+ (void) savePostedToFacebookStatus: (BOOL)status;
+ (BOOL) loadPostedToFacebookStatus;
+ (void) saveAppRunCount: (int)count;
+ (int) loadAppRunCount;
+ (void) saveIsRated: (BOOL)status;
+ (BOOL) loadIsRated;
+ (void) saveFeaturedAppCount: (int)count;
+ (int) loadFeaturedAppCount;
+ (void) saveFAEDLinkCount: (int)count;
+ (int) loadFAEDLinkCount;

+ (void) setRevMobFeaturedAdEnabled :(BOOL) status;
+ (void) setRevMobOfferWallEnabled :(BOOL) status;
+ (void) setTapJoyBannerAdEnabled :(BOOL) status;
+ (void) setTapJoyFeaturedAdEnabled :(BOOL) status;
+ (void) setTapJoyOfferWallEnabled :(BOOL) status;
+ (void) setChartboostFeaturedAdEnabled :(BOOL) status;
+ (void) setChartboostOfferWallEnabled :(BOOL) status;
+ (void) setMobclixBannerAdEnabled :(BOOL) status;
+ (void) setMobclixFeaturedAdEnabled :(BOOL) status;
+ (void) setMobclixOfferWallEnabled :(BOOL) status;
+ (void) setAdsRemoved :(BOOL) status;

+ (int) getAppBecomeActive;
+ (int) getFreeGamesSettings;
+ (int) getFreeGamesGameover;
+ (int) getBonusGameInstructions;
+ (int) getBonusGameMain;
+ (void) setAppBecomeActive :(int) service;
+ (void) setFreeGamesSettings :(int) service;
+ (void) setFreeGamesGameover :(int) service;
+ (void) setBonusGameMainService :(int) service;
+ (void) setBonusGameInstructions :(int) service;
+ (int) getFeaturedAdGameover;
+ (void) setFeaturedAdGameover :(int) service;

+ (void) setAutoFeaturedAdPauseScreen :(int) service;
+ (int) getAutoFeaturedAdPauseScreen;
+ (void) setAutoFeaturedAdSplashScreen :(int) service;
+ (int) getAutoFeaturedAdSplashScreen;

+ (BOOL) isAdsRemoved;
+ (BOOL) isRevMobFeaturedAdEnabled;
+ (BOOL) isRevMobOfferWallEnabled;
+ (BOOL) isTapJoyBannerAdEnabled;
+ (BOOL) isTapJoyFeaturedAdEnabled;
+ (BOOL) isTapJoyOfferWallEnabled;
+ (BOOL) isMobclixBannerAdEnabled;
+ (BOOL) isMobclixFeaturedAdEnabled;
+ (BOOL) isMobclixOfferWallEnabled;
+ (BOOL) isChartboostFeaturedAdEnabled;
+ (BOOL) isChartboostOfferWallEnabled;
+ (BOOL) isFlurryEnabled;
+ (BOOL) isPushWooshEnabled;
+ (NSString*) getFacebookPageLink;
+ (NSString*) getTwitterPageLink;

+ (NSDictionary *) loadVersionFile;
+ (void) saveVersionFile :(NSMutableData *) data;
+ (float) getVersionNumberLatest;
+ (void) setVersionNumberLatest :(float) versionNumber;
+ (void) setVersionNumberReview :(float) versionNumber;
+ (float) getVersionNumberReview;
+ (void) setInReview :(BOOL) status;
+ (BOOL) isInReview;


+ (NSDictionary *) loadConfigFile;
+ (void) saveConfigFile :(NSMutableData *) data;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;



@end
