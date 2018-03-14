//
//  SimpleDPad.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Score.h"
#import <GameKit/GameKit.h>
#import "GamePauseScene.h"

@implementation Score

+(id)scoreShow
{
    return [[self alloc] initScore];
}

-(id)initScore
{
    if ((self = [super init]))
    {
        CCSprite* scoresTitle = [CCSprite spriteWithFile:@"score.png"];
        scoresTitle.anchorPoint = CGPointMake(0, 0);
        scoresTitle.position = ccp(-90, -12);
        [self addChild: scoresTitle z:3];
        
        scoresValue = [CCSprite spriteWithFile:@"score_0.png"];
        scoresValue.anchorPoint = CGPointMake(0, 0);
        scoresValue.position =  ccp(86, -29);
        [self addChild: scoresValue z:3];
        
        CCSprite* highScoresTitle = [CCSprite spriteWithFile:@"highscore.png"];
        highScoresTitle.anchorPoint = CGPointMake(0, 0);
        highScoresTitle.position = ccp(-28, 20);
        [self addChild: highScoresTitle z:3];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long int oldHighScore = [[defaults valueForKey:tHIGHSCORE ] intValue];
        
        if(oldHighScore==0)
        {
            highScoresValue = [CCSprite spriteWithFile:@"highscore_0.png"];
            highScoresValue.position =  ccp(92, 12);
            [self addChild: highScoresValue z:3];
        }
        else if(oldHighScore>0)
        {
            long int oldHighScore_digit = oldHighScore;
            int round=0;
            int digit=0;
            while(oldHighScore_digit>0)
            {
                digit = oldHighScore_digit % 10;
                highScoresValue = [CCSprite spriteWithFile:[NSString stringWithFormat:@"highscore_%d.png", digit]];
                highScoresValue.position =  ccp(92-round*13, 12);
                [self addChild: highScoresValue z:3];
                
                round++;
                oldHighScore_digit /= 10;
            }
        }
        
        celebrateState=FALSE;
        
        //Add a in-game pause button here
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage: @"btn_menupause.png"
                                                             selectedImage:@"btn_menupause.png"
                                                                    target:self
                                                                  selector:@selector(pauseGame:)];

        CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
        myMenu.position = ccp(120, 20);
        [myMenu alignItemsVertically];
        //[[AdsManager sharedAdsManager] showAdOnPause];
        [self addChild:myMenu z:3];
        
        
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)dt
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long int oldHighScore = [[defaults valueForKey:tHIGHSCORE ] intValue];
    int round=0;
    int digit=0;
    long int score_digit=0;
    
    if ((oldHighScore >= gGameScore)&&(gGameScore>gGameScore_Last))
    {
        score_digit = gGameScore;
        round=0;
        digit=0;
        while(score_digit>0)
        {
            scoresValue = (CCSprite*) [self getChildByTag:(round+10)];
            [self removeChild:scoresValue cleanup:YES];
            
            digit = score_digit % 10;
            scoresValue = [CCSprite spriteWithFile:[NSString stringWithFormat:@"score_%d.png", digit]];
            scoresValue.anchorPoint = CGPointMake(0, 0);
            scoresValue.position =  ccp(86-round*13, -28);
            [self addChild: scoresValue z:3 tag:(round+10)];
            
            round++;
            score_digit /= 10;
        }
        
        gGameScore_Last = gGameScore;
    }
    else if((oldHighScore < gGameScore)&&(gGameScore>gGameScore_Last))
    {
        score_digit = gGameScore;
        round=0;
        digit=0;
        while(score_digit>0)
        {
            scoresValue = (CCSprite*) [self getChildByTag:(round+10)];
            [self removeChild:scoresValue cleanup:YES];
            
            digit = score_digit % 10;
            scoresValue = [CCSprite spriteWithFile:[NSString stringWithFormat:@"score_%d.png", digit]];
            scoresValue.anchorPoint = CGPointMake(0, 0);
            scoresValue.position =  ccp(86-round*13, -28);
            [self addChild: scoresValue z:3 tag:(round+10)];
            
            round++;
            score_digit /= 10;
        }
        
        score_digit = gGameScore;
        round=0;
        digit=0;
        while(score_digit>0)
        {
            scoresValue = (CCSprite*) [self getChildByTag:(round+20)];
            [self removeChild:scoresValue cleanup:YES];
            
            digit = score_digit % 10;
            highScoresValue = [CCSprite spriteWithFile:[NSString stringWithFormat:@"highscore_%d.png", digit]];
            highScoresValue.position =  ccp(92-round*13, 12);
            [self addChild: highScoresValue z:3 tag:(round+20)];
            
            round++;
            score_digit /= 10;
        }
        
        
        if(celebrateState==FALSE)
        {
            CCSprite* celebrate = [CCSprite spriteWithFile:@"newhighscore.png"];
            celebrate.anchorPoint = CGPointMake(0, 0);
            celebrate.position = ccp(-48, -48);
            [self addChild: celebrate z:3];
            
            celebrateState=TRUE;
        }
     
        //update the high score stored locally
        [defaults setInteger:gGameScore forKey:tHIGHSCORE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //save high score to leaderboard
        [self saveScoreToGameCenter: gGameScore];
        
        gGameScore_Last = gGameScore;
    }
    

}


-(void) pauseGame: (id) sender {    
    GamePauseScene *pauseScene = [GamePauseScene node];
    [[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5 scene:pauseScene]];
}


- (void) saveScoreToGameCenter: (int) score {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            //Add new score
            GKScore *myScoreValue = [[GKScore alloc] initWithCategory:LEADERBOARD_ID];
            myScoreValue.value = score;
            
            [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
                if(error != nil){
                    NSLog(@"Score Submission Failed");
                } else {
                    NSLog(@"Score Submitted");
                }
                
            }];
            
            /*
             //Update achievements
             if (score >= 25000)
             {
             GKAchievement *achievement;
             achievement= [[GKAchievement alloc] initWithIdentifier:@"aa.25000"];
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
             achievement= [[GKAchievement alloc] initWithIdentifier:@"aa.10000"];
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
             achievement= [[GKAchievement alloc] initWithIdentifier:@"aa.5000"];
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
             */
        }
    }];
	
}



@end
