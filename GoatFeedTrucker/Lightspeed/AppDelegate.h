#import <UIKit/UIKit.h>

#import "PushNotificationManager.h"

#define USERNAME @""
#define PASSWORD @""

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
	UIWindow *window;
    IBOutlet UIView					*mainView;
    
    NSMutableData *responseData;
    UIButton *adCloseButton;
	
    UIButton *restoreIAPButton;
}

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIWindow *window;

-(void) scheduleAlarm;
- (void) gotoAppStore;
- (void) checkForLatestVersion;
-(NSString*) getRandomLocalPushMessage;
@end
