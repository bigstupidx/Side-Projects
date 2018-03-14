#import "PauseScene.h"
#import "Globals.h"
#import "AdsManager.h"
#import "StarParticleLayer.h"

#import "MainMenuLayer.h"

@implementation PauseScene

- (id) init
{
	self = [super init];
    
    
    
    
    CCMenuItem *gobackItem, *mmItem;   
	if (self)
	{
        // Particle System Layer
        StarParticleLayer *particleLayer = [StarParticleLayer node];
        [self addChild:particleLayer z:-1];
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //if we are dealing with iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-paused.png"];
            //background.contentSize = CGSizeMake(winSize.width, winSize.height);
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            CGSize menuItemSize = CGSizeMake(208, 84);
            gobackItem = [CCMenuItem itemWithTarget:self selector:@selector(resumeGame:)];
            [gobackItem setContentSize:menuItemSize];
            [gobackItem setPosition:ccp(winSize.width*0.31, winSize.height*0.62)];
            
            mmItem = [CCMenuItem itemWithTarget:self selector:@selector(exitToMainMenu:)];
            [mmItem setContentSize:menuItemSize];
            [mmItem setPosition:ccp(winSize.width*0.31, winSize.height*0.51)];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGSize menuItemSize = CGSizeMake(466, 184);
            
            CCSprite* background = [CCSprite spriteWithFile:@"lg-paused-ipad.png"];
            //background.contentSize = CGSizeMake(winSize.width, winSize.height);
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            gobackItem = [CCMenuItem itemWithTarget:self selector:@selector(resumeGame:)];
            [gobackItem setContentSize:menuItemSize];
            [gobackItem setPosition:ccp(winSize.width*0.31, winSize.height*0.62)];
            
            mmItem = [CCMenuItem itemWithTarget:self selector:@selector(exitToMainMenu:)];
            [mmItem setContentSize:menuItemSize];
            [mmItem setPosition:ccp(winSize.width*0.31, winSize.height*0.51)];
        }
        else {
            return nil;
        }
        
        CCMenu *menu = [CCMenu menuWithItems:mmItem, gobackItem, nil];
        [menu setPosition: ccp(0, 0)];
        
        [[AdsManager sharedAdsManager] showAdOnPause];
        [self addChild:menu];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	
}

- (void) resumeGame: (id) sender
{
	gGameSuspended = FALSE;
	
	[[CCDirector sharedDirector] popScene];
}

- (void) exitToMainMenu: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}


@end
