//
//  OptionsMenulayer.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-04.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "OptionsMenuLayer.h"
#import "InstructionsMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "Globals.h"
#import "StarParticleLayer.h"
#import "CreditsLayer.h"
@implementation OptionsMenuLayer


+(id) scene{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [OptionsMenuLayer node];
    [scene addChild: layer];
    return scene;
}


- (id) init
{
	self = [super init];
    
    CCMenuItem *gobackItem, * instructionsItem;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
	if (self)
	{
        // Particle System Layer
        StarParticleLayer *particleLayer = [StarParticleLayer node];
        [self addChild:particleLayer z:-1];
        
        //if we are dealing with iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (winSize.height > 960/2)
            {
                
                CGPoint pos = ccp(0, (1136 - 960)/2/2);
                [self setPosition:pos];
                //[self setPosition:ccpAdd([self.position], ccp(0, )];
            }
            winSize = CGSizeMake(640*0.5, 960*0.5);
            
            
            
            CCSprite* background = [CCSprite spriteWithFile:@"lg-options.png"];
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            
            //add the menu items
            CGSize menuItemSize = CGSizeMake(208, 84);
            
            gobackItem = [CCMenuItem itemWithTarget:self selector:@selector(goback:)];
            [gobackItem setContentSize:menuItemSize];
            [gobackItem setPosition:ccp(winSize.width*0.32, winSize.height*0.62)];
            
            
            instructionsItem = [CCMenuItem itemWithTarget:self selector:@selector(instructions:)];
            [instructionsItem  setContentSize:menuItemSize];
            [instructionsItem setPosition:ccp(winSize.width*0.32, winSize.height*0.51)];
            
            [CCMenuItemFont setFontSize:20];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-options-ipad.png"];
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            CGSize menuItemSize = CGSizeMake(466, 184);
            
            //add the menu items
            gobackItem = [CCMenuItem itemWithTarget:self selector:@selector(goback:)];
            [gobackItem setContentSize:menuItemSize];
            [gobackItem setPosition:ccp(winSize.width*0.31, winSize.height*0.62)];
            
            instructionsItem = [CCMenuItem itemWithTarget:self selector:@selector(instructions:)];
            [instructionsItem  setContentSize:menuItemSize];
            [instructionsItem setPosition:ccp(winSize.width*0.31, winSize.height*0.51)];
    

            [CCMenuItemFont setFontSize:40];
        }
        else {
            return nil;
        }
        
		[CCMenuItemFont setFontName:FONT_NAME];
		CCMenuItemToggle *soundToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleSound:) items:
                                   [CCMenuItemFont itemFromString: @"On"],
                                   [CCMenuItemFont itemFromString: @"Off"],
                                   nil];
		CCMenuItemToggle *musicToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleMusic:) items:
                                         [CCMenuItemFont itemFromString: @"On"],
                                         [CCMenuItemFont itemFromString: @"Off"],
                                         nil];
        
        [soundToggle setColor:ccBLACK];
        [musicToggle setColor:ccBLACK];
        
        if ([SimpleAudioEngine sharedEngine].effectsVolume > 0.0)
        {
            soundToggle.selectedIndex = 0;
        }
        else {
            soundToggle.selectedIndex = 1;
        }
        
        if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume > 0.0)
        {
            musicToggle.selectedIndex = 0;
        }
        else {
            musicToggle.selectedIndex = 1;
        }
        
        musicToggle.position = ccp(winSize.width*0.44, winSize.height*0.280);
        soundToggle.position = ccp(winSize.width*0.44, winSize.height*0.230);

        
        CCMenu *menu = [CCMenu menuWithItems:instructionsItem,  gobackItem, soundToggle, musicToggle, nil];
        [menu setPosition: ccp(0, 0)];

        [self addChild:menu];
	}
	return self;
}

- (void) toggleSound: (id) sender
{
    if ([SimpleAudioEngine sharedEngine].effectsVolume > 0.0)
    {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
    }
    else {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
    }
}

- (void) toggleMusic: (id) sender
{
    if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume > 0.0)
    {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
    }
    else {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
    }
}

- (void) goback: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];

    [[CCDirector sharedDirector] popScene];
    
}

- (void) instructions: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];

    [[CCDirector sharedDirector] pushScene: 
	 [InstructionsMenuLayer scene]];
    
}

- (void) creditsPressed: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];
    
    [[CCDirector sharedDirector] pushScene:
	 [CreditsLayer scene]];
    
}

@end
