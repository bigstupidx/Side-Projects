//
//  OptionsMenulayer.m
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-04.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "OptionsMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "Globals.h"

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
    
    //CCMenuItem *gobackItem;
	if (self)
	{
        CCSprite* backgroundBanboo = [CCSprite spriteWithFile:@"Menu_Options.png"];
        backgroundBanboo.position = ccp(220,170);
        [self addChild:backgroundBanboo z:1];
        
        
        CCMenu * menuButton;
        
        //Meng: create music button
        if(gGamesMusicStatus==TRUE)
        {
            menuMusic = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Options_Music_ON.png"
                                               selectedImage: @"Menu_Button_Options_Music_ON.png"
                                                      target:self
                                                    selector:@selector(musicChange:)];
            menuButton = [CCMenu menuWithItems:menuMusic, nil];
            menuButton.position = ccp(200, 120);
            [self addChild:menuButton z:3];
        }
        else if(gGamesMusicStatus==FALSE)
        {
            menuMusic = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Options_Music_OFF.png"
                                               selectedImage: @"Menu_Button_Options_Music_OFF.png"
                                                      target:self
                                                    selector:@selector(musicChange:)];
            menuButton = [CCMenu menuWithItems:menuMusic, nil];
            menuButton.position = ccp(200, 120);
            [self addChild:menuButton z:3];
        }
    
        //Meng: create sound effect button
        if(gGamesEffectStatus==TRUE)
        {
            menuEffect = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Options_Effect_ON.png"
                                                selectedImage: @"Menu_Button_Options_Effect_ON.png"
                                                       target:self
                                                     selector:@selector(effectChange:)];
            menuButton = [CCMenu menuWithItems:menuEffect, nil];
            menuButton.position = ccp(280, 120);
            [self addChild:menuButton z:3];
        }
        else if(gGamesEffectStatus==FALSE)
        {
            menuEffect = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Options_Effect_OFF.png"
                                                selectedImage: @"Menu_Button_Options_Effect_OFF.png"
                                                       target:self
                                                     selector:@selector(effectChange:)];
            menuButton = [CCMenu menuWithItems:menuEffect, nil];
            menuButton.position = ccp(280, 120);
            [self addChild:menuButton z:3];
        }
        
        //Meng: create back button 
        menuBack = [CCMenuItemImage itemWithNormalImage:@"Menu_Button_Options_Back.png"
                                                                selectedImage: @"Menu_Button_Options_Back_Chosen.png"
                                                                       target:self
                                                                     selector:@selector(backToMainMenu:)];
        menuButton = [CCMenu menuWithItems:menuBack, nil];
        menuButton.position = ccp(40, 40);
        [self addChild:menuButton z:3];
	}
	return self;
}


-(void) musicChange: (id) sender{
    if(gGamesMusicStatus==TRUE)
    {
        gGamesMusicStatus = FALSE;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f]; //Turn off background music
        
        CCMenuItemSprite* musicImage =[CCSprite spriteWithFile:@"Menu_Button_Options_Music_OFF.png"];
        [menuMusic setNormalImage:musicImage];
        
    }
    else if(gGamesMusicStatus==FALSE)
    {
        gGamesMusicStatus = TRUE;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f]; //Turn on background music
        
        CCMenuItemSprite* musicImage =[CCSprite spriteWithFile:@"Menu_Button_Options_Music_ON.png"];
        [menuMusic setNormalImage:musicImage];
    }
}

-(void) effectChange: (id) sender{
    if(gGamesEffectStatus==TRUE)
    {
        gGamesEffectStatus = FALSE;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f]; //Turn off music effect
        
        CCMenuItemSprite* effectImage =[CCSprite spriteWithFile:@"Menu_Button_Options_Effect_OFF.png"];
        [menuEffect setNormalImage:effectImage];
        
    }
    else if(gGamesEffectStatus==FALSE)
    {
        gGamesEffectStatus = TRUE;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f]; //Turn on music effect
        
        CCMenuItemSprite* effectImage =[CCSprite spriteWithFile:@"Menu_Button_Options_Effect_ON.png"];
        [menuEffect setNormalImage:effectImage];
    }
}

- (void) backToMainMenu: (id) sender
{
    [[CCDirector sharedDirector] popScene]; //Go back to main menu
}



@end
