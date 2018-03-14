//
//  GameoverLayer.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-05.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "GameoverLayer.h"
#import "Globals.h"
#import "GameplayLayer.h"
#import "AdsManager.h"
#import "MainMenuLayer.h"

#import "StarParticleLayer.h"

@implementation GameoverLayer

- (id) init
{
	self = [super init];
    
    CCMenuItem *playagainItem, *mmItem;   
    
    
	if (self)
	{
        // Particle System Layer
        StarParticleLayer *particleLayer = [StarParticleLayer node];
        [self addChild:particleLayer z:-1];
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //if we are dealing with iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-gameover.png"];
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);

            winSize = CGSizeMake(640*0.5, 960*0.5);
            
            CGSize menuItemSize = CGSizeMake(208, 84);
            //playagainItem = [CCMenuItem itemWithTarget:self selector:@selector(restartGame:)];
            playagainItem = [CCMenuItem itemWithTarget:self selector:@selector(exitToMainMenu:)];
            [playagainItem setContentSize:menuItemSize];
            [playagainItem setPosition:ccp(winSize.width*0.31, winSize.height*0.62)];
            
            mmItem = [CCMenuItem itemWithTarget:self selector:@selector(exitToMainMenu:)];
            [mmItem setContentSize:menuItemSize];
            [mmItem setPosition:ccp(winSize.width*0.31, winSize.height*0.51)];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-gameover-ipad.png"];
                        [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            CGSize menuItemSize = CGSizeMake(466, 184);
            playagainItem = [CCMenuItem itemWithTarget:self selector:@selector(exitToMainMenu:)];
            [playagainItem setContentSize:menuItemSize];
            [playagainItem setPosition:ccp(winSize.width*0.30, winSize.height*0.62)];
            
            mmItem = [CCMenuItem itemWithTarget:self selector:@selector(exitToMainMenu:)];
            [mmItem setContentSize:menuItemSize];
            [mmItem setPosition:ccp(winSize.width*0.30, winSize.height*0.51)];
        }
        else {
            return nil;
        }
        
        CCMenu *menu = [CCMenu menuWithItems:playagainItem, mmItem, nil];
        [menu setPosition: ccp(0, 0)];
        [self addChild:menu];
        
        [[AdsManager sharedAdsManager] showAdOnGameOver];
	}
	return self;
}

- (void) setScore: (int) s{
    

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint scoreLabelPos;
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
         scoreLabelPos = ccp(winSize.width*0.77,winSize.height*0.23);
     }
    else
    {
        //winSize = CGSizeMake(640*0.5, 960*0.5);
        if (winSize.height > 960*0.5)
        {
            scoreLabelPos = ccp(winSize.width*0.77,winSize.height*0.3);
            
        }
        else
        {
            scoreLabelPos = ccp(winSize.width*0.77,winSize.height*0.27);
        }
    }
    
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",s] fontName:FONT_NAME fontSize:FS_HIGHSCORE];
    [scoreLabel setColor:FONT_COLOR];
    [self addChild:scoreLabel z:5];
    scoreLabel.position = scoreLabelPos;
    
    //save score internally
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int oldHighScore = [[defaults valueForKey:tHIGHSCORE ] intValue];
    
    if (s > oldHighScore)
    {
        [defaults setInteger:s forKey:tHIGHSCORE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //attempt to save to game center
    [self saveScoreToGameCenter: s];
}

- (void) dealloc
{
	[super dealloc];
	
}

- (void) restartGame: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:1.0 
										scene:[GameplayLayer scene]
									withColor:ccWHITE]];
}


- (void) saveScoreToGameCenter: (int) score {
    
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            //Add new score
            GKScore *myScoreValue = [[[GKScore alloc] initWithCategory:LEADERBOARD_ID] autorelease];
            myScoreValue.value = score;
            
            [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
                if(error != nil){
                    NSLog(@"Score Submission Failed");
                } else {
                    NSLog(@"Score Submitted");
                }
                
            }];
            
            
            //Update achievements
            if (score > 100000)
            {
                GKAchievement *achievement;
                achievement= [[[GKAchievement alloc] initWithIdentifier:@"com.slightlysocial.theharlemdead.100000"] autorelease];
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
            else if (score >= 50000)
            {
                GKAchievement *achievement;
                achievement= [[[GKAchievement alloc] initWithIdentifier:@"com.slightlysocial.theharlemdead.50000"] autorelease];
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
            else if (score >= 25000)
            {
                GKAchievement *achievement;
                achievement= [[[GKAchievement alloc] initWithIdentifier:@"com.slightlysocial.theharlemdead.25000"] autorelease];
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
            else if (score >= 10000)
            {
                GKAchievement *achievement;
                achievement= [[[GKAchievement alloc] initWithIdentifier:@"com.slightlysocial.theharlemdead.10000"] autorelease];
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
            else if (score >= 5000)
            {
                GKAchievement *achievement;
                achievement= [[[GKAchievement alloc] initWithIdentifier:@"com.slightlysocial.theharlemdead.5000"] autorelease];
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
    }];
	
}

- (void) exitToMainMenu: (id) sender
{
	[[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:1.0 
										scene:[MainMenuLayer scene]
									withColor:ccBLACK]];
	
	gGameSuspended = YES;
    
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


@end
