#import "MainMenuLayer.h"
#import "Globals.h"
#import "OptionsMenulayer.h"
#import "SimpleAudioEngine.h"

#import "Util.h"

//facebook and twitter stuff

#import "AdsManager.h"
#import "InAppPurchaseManager.h"

#import "StarParticleLayer.h"

#import "GameplayLayer.h"

@implementation MainMenuLayer

#define kMenuSpriteManager 1001
#define kMenuPlayerTag 1002

+ (id) scene
{
    CCScene* currScene = [CCScene node];
    MainMenuLayer *menuLayer = [MainMenuLayer node];
    [currScene addChild:menuLayer z:0];
    
    // Particle System Layer
    StarParticleLayer *particleLayer = [StarParticleLayer node];
    [currScene addChild:particleLayer z:-1];
    return currScene;
}

- (id) init
{
	self = [super init];
    
    CCMenuItem *singlePlayerItem, *optionsItem, *leaderBoardItem, *achievementsItem, *restoreItem, *freeGameItem;
    CCMenuItem *testItem = [CCMenuItem itemWithTarget:self selector:@selector(singlePlayer:)];
    [testItem setContentSize:CGSizeMake(50, 50)];
    
	if (self)
	{
		reset_globals();
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        
        //get the current high score
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int highScore = [defaults integerForKey:tHIGHSCORE];
        //highScore = 1235;
        NSString* labelString = [NSString stringWithFormat:@"%d",highScore];
        CCLabelTTF* hsLabel = [CCLabelTTF labelWithString:labelString fontName:FONT_NAME fontSize:FS_HIGHSCORE];
        [hsLabel setColor:FONT_COLOR];
        [hsLabel setRotation:-7];
        [self addChild:hsLabel];
        
        //if we are dealing with iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //Free game button
            freeGameItem = [CCMenuItemImage itemFromNormalImage:@"redfreegame.png" selectedImage:@"redfreegame.png" target:self selector:@selector(freeGameButtonClicked:)];
            
            [freeGameItem setPosition:ccp(winSize.width-freeGameItem.contentSize.width*0.5, freeGameItem.contentSize.height*0.5)];
            
            if (winSize.height > 960/2)
            {
                
                CGPoint pos = ccp(0, (1136 - 960)/2/2);
                [self setPosition:pos];
                //[self setPosition:ccpAdd([self.position], ccp(0, )];
            }
            winSize = CGSizeMake(640*0.5, 960*0.5);
            
            CCSprite* background = [CCSprite spriteWithFile:@"lg-mainmenu.png"];
            
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            CGSize menuItemSize = CGSizeMake(208, 84);
            
            singlePlayerItem = [CCMenuItem itemWithTarget:self selector:@selector(singlePlayer:)];
            [singlePlayerItem setPosition:ccp(winSize.width*0.32, winSize.height*0.62)];
            [singlePlayerItem setContentSize:menuItemSize];
            
            optionsItem = [CCMenuItem itemWithTarget:self selector:@selector(options:)];
            [optionsItem setPosition:ccp(winSize.width*0.32, winSize.height*0.510)];
            [optionsItem setContentSize:menuItemSize];
            
            leaderBoardItem = [CCMenuItem itemWithTarget:self selector:@selector(showLeaderboard:)];
            [leaderBoardItem setPosition:ccp(winSize.width*0.32, winSize.height*0.400)];
            [leaderBoardItem setContentSize:menuItemSize];
            
            achievementsItem = [CCMenuItem itemWithTarget:self selector:@selector(showAchievements:)];
            [achievementsItem setPosition:ccp(winSize.width*0.32, winSize.height*0.287)];
            [achievementsItem setContentSize:menuItemSize];
            
            restoreItem = [CCMenuItem itemWithTarget:self selector:@selector(restore:)];
            [restoreItem setPosition:ccp(winSize.width*0.32, winSize.height*0.177)];
            [restoreItem setContentSize:menuItemSize];
            
            [hsLabel setPosition:ccp(winSize.width*0.83, winSize.height*0.62)];
            
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGSize menuItemSize = CGSizeMake(466, 184);
            
            singlePlayerItem = [CCMenuItem itemWithTarget:self selector:@selector(singlePlayer:)];
            [singlePlayerItem setPosition:ccp(winSize.width*0.30, winSize.height*0.64)];
            [singlePlayerItem setContentSize:menuItemSize];
            
            optionsItem = [CCMenuItem itemWithTarget:self selector:@selector(options:)];
            [optionsItem setPosition:ccp(winSize.width*0.30, winSize.height*0.525)];
            [optionsItem setContentSize:menuItemSize];
            
            leaderBoardItem = [CCMenuItem itemWithTarget:self selector:@selector(showLeaderboard:)];
            [leaderBoardItem setPosition:ccp(winSize.width*0.30, winSize.height*0.41)];
            [leaderBoardItem setContentSize:menuItemSize];
            
            achievementsItem = [CCMenuItem itemWithTarget:self selector:@selector(showAchievements:)];
            [achievementsItem setPosition:ccp(winSize.width*0.30, winSize.height*0.289)];
            [achievementsItem setContentSize:menuItemSize];
            
            restoreItem = [CCMenuItem itemWithTarget:self selector:@selector(restore:)];
            [restoreItem setPosition:ccp(winSize.width*0.30, winSize.height*0.177)];
            [restoreItem setContentSize:menuItemSize];
            
            CCSprite* background = [CCSprite spriteWithFile:@"lg-mainmenu-ipad.png"];
            //background.contentSize = CGSizeMake(winSize.width, winSize.height);
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            //Free game button
            freeGameItem = [CCMenuItemImage itemFromNormalImage:@"redfreegame-ipad.png" selectedImage:@"redfreegame-ipad.png" target:self selector:@selector(freeGameButtonClicked:)];
            
            [freeGameItem setPosition:ccp(winSize.width-freeGameItem.contentSize.width*0.5, freeGameItem.contentSize.height*0.5)];
            
            [hsLabel setPosition:ccp(winSize.width*0.83, winSize.height*0.62)];
        }
        
        //must be in reverse order because this is the order that they are registered with touch
        CCMenu *menu = [CCMenu menuWithItems:restoreItem, achievementsItem, leaderBoardItem, optionsItem, singlePlayerItem, freeGameItem, nil];
        
        [menu setPosition: ccp(0, 0)];
        
        if ([[AdsManager sharedAdsManager] isInReview] == 0 || [[AdsManager sharedAdsManager] adOnFreeGame] <= 0)
        {
            freeGameItem.visible = false;
        }
        [self addChild:menu];
        
        //add the add!
        
        [[AdsManager sharedAdsManager] cancelAd];//cancels the banner ad
        //view controller for the leaderboard
        tempVC=[[UIViewController alloc] init] ;
        [self authenticateLocalPlayer];
	}
	return self;
}


- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated)
        return;
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil)
        {
            NSLog(@"Authentication successful");
        }
        else {
            NSLog(@"Authentical failed");
        }
    }];
    
}

- (void) options: (id) sender
{
    [[CCDirector sharedDirector] pushScene: 
	 [OptionsMenuLayer scene]];
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];
}

- (void) restore: (id) sender
{
    
    //restore the completedtransactions
	[[InAppPurchaseManager sharedInAppManager] restoreCompletedTransactions];
}

- (void) singlePlayer: (id) sender
{
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];
    
    [[CCDirector sharedDirector] replaceScene:[GameplayLayer scene]];
    
}

-(void)showLeaderboard:(id)sender
{
  
    [self authenticateLocalPlayer];
    
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    
    if (leaderboardViewController != nil)
    {
        [leaderboardViewController setCategory:LEADERBOARD_ID];
        [leaderboardViewController setTitle:@"High Scores"];
        leaderboardViewController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardViewController.leaderboardDelegate = self;
        [[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
        [tempVC presentModalViewController:leaderboardViewController animated:YES];
        [leaderboardViewController release];
    }
    }

-(void)showAchievements:(id)sender
{    
    
    [self authenticateLocalPlayer];
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];
    
    GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
    if (achivementViewController != nil)
    {
        achivementViewController.achievementDelegate = self;
        [[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
        
        [tempVC presentModalViewController:achivementViewController animated:YES];
        
        [achivementViewController release];
    }
    	
}

#pragma mark GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[tempVC dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[tempVC dismissModalViewControllerAnimated:YES];
}

//Facebook
- (void) facebookCallback: (id) sender
{
   
}

//Twitter
- (void) twitterCallback: (id) sender
{
      
}


-(void) freeGameButtonClicked:(id)sender {
    
    [[AdsManager sharedAdsManager] clickFreeGameButton];
}

@end
