
#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "Audio.h"
#import "GameKitLibrary.h"

#include <sys/sysctl.h>

@class MenuViewController;
@class Audio;
@class GameKitLibrary;

@interface FruitSlayerAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	MenuViewController *menuViewController;
	
	bool highPerformance;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MenuViewController *menuViewController;
@property (nonatomic) bool highPerformance;

-(bool) isHighPerformanceSystem;

@end