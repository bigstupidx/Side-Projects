//
//  GameoverLayer.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-05.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "GameoverLayer.h"
#import "Globals.h"
#import "Nextpeer/Nextpeer.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "GameKitLibrary.h"
#import "AdsManager.h"

@implementation GameoverLayer

- (id) init
{
	self = [super init];
    
    CCMenuItem *playagainItem, *mmItem;   
    
    CGFloat fontSize = 30;
	if (self)
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //if we are dealing with iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-gameover.png"];
            //background.contentSize = CGSizeMake(winSize.width, winSize.height);
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            playagainItem = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(restartGame:)];
            
            [playagainItem setPosition:ccp(winSize.width*0.25, winSize.height*0.40)];
            
            mmItem = [CCMenuItemImage itemFromNormalImage:@"mainmenu.png" selectedImage:@"mainmenu.png" target:self selector:@selector(exitToMainMenu:)];
            
            [mmItem setPosition:ccp(winSize.width*0.25, winSize.height*0.29)];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-gameover-ipad.png"];
            fontSize = 40;
            //background.contentSize = CGSizeMake(winSize.width, winSize.height);
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            playagainItem = [CCMenuItemImage itemFromNormalImage:@"resume-ipad.png" selectedImage:@"resume-ipad.png" target:self selector:@selector(restartGame:)];
            
            [playagainItem setPosition:ccp(winSize.width*0.25, winSize.height*0.40)];
            
            mmItem = [CCMenuItemImage itemFromNormalImage:@"mainmenu-ipad.png" selectedImage:@"mainmenu-ipad.png" target:self selector:@selector(exitToMainMenu:)];
            
            [mmItem setPosition:ccp(winSize.width*0.25, winSize.height*0.29)];
        }
        else {
            return nil;
        }
        
        CCMenu *menu = [CCMenu menuWithItems:playagainItem, mmItem, nil];
        [menu setPosition: ccp(0, 0)];
        [self addChild:menu];
        
        [[AdsManager sharedAdsManager] showAdOnGameOver];
	}
    highScore = 0;
	return self;
}

- (void) setScore: (int) s{
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",s] fontName:@"futurafont.ttf" fontSize:26];
    [self addChild:scoreLabel z:5];
    highScore = s;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    scoreLabel.position = ccp(winSize.width*0.77,winSize.height*0.39);
    
    [self saveScoreToGameCenter];
}

- (void) dealloc
{
	[super dealloc];
	
}

- (void) restartGame: (id) sender
{
    [self saveScoreToGameCenter];
	[[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:1.0 
										scene:[GameScene node]
									withColor:ccSkyBlue]];
}


- (void) saveScoreToGameCenter {
    
	//Add new score
    GKScore *myScoreValue = [[[GKScore alloc] initWithCategory:@"ls.highscore"] autorelease];
	myScoreValue.value = highScore;
	
	[myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
		if(error != nil){
			NSLog(@"Score Submission Failed");
		} else {
			NSLog(@"Score Submitted");
		}
        
	}];
	
	//Update achievements
    GKAchievement *achievement;
    
	if (highScore >= 2000) 
	{
        achievement= [[[GKAchievement alloc] initWithIdentifier:@"ls.champion"] autorelease];
        achievement.percentComplete = 100.0;
        
        if(achievement!= NULL)
            [achievement reportAchievementWithCompletionHandler: ^(NSError *error){
				if(error != nil){
					NSLog(@"Achievement failed");
				} else {
					NSLog(@"Achievement Success");
				}
                
            }];
        
	}
}

- (void) exitToMainMenu: (id) sender
{
    
	
	[[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:1.0 
										scene:[MenuScene node]
									withColor:ccSkyBlue]];
	
	gGameSuspended = YES;
    
   
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


@end
