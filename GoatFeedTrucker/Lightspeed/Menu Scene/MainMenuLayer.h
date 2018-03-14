#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <RevMobAds/RevMobAds.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, RevMobAdsDelegate>
{

    UIViewController *tempVC;    
}

+ (id) scene;

- (void) multiplayer: (id) sender;
- (void) singlePlayer: (id) sender;

-(void) freeGameButtonClicked:(id)sender;
-(void)showLeaderboard:(id)sender;
-(void)showAchievements:(id)sender;
- (void) freeGameButtonClicked:(id)sender;
- (void) twitterCallback: (id) sender;
- (void) facebookCallback: (id) sender;
- (void) authenticateLocalPlayer;
@end
