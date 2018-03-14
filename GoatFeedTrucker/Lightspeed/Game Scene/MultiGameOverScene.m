#import "MultiGameOverScene.h"
#import "Globals.h"

@implementation MultiGameOverScene


- (id) init
{
	self = [super init];
    
    CCMenuItem *playagainItem, *mmItem;   
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
            
            playagainItem = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(resumeGame:)];
            
            [playagainItem setPosition:ccp(winSize.width*0.25, winSize.height*0.40)];
            
            mmItem = [CCMenuItemImage itemFromNormalImage:@"mainmenu.png" selectedImage:@"mainmenu.png" target:self selector:@selector(exitToMainMenu:)];
            
            [mmItem setPosition:ccp(winSize.width*0.25, winSize.height*0.29)];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CCSprite* background = [CCSprite spriteWithFile:@"lg-gameover-ipad.png"];
            //background.contentSize = CGSizeMake(winSize.width, winSize.height);
            [self addChild:background z:-1];
            background.position = ccp(winSize.width/2, winSize.height/2);
            
            playagainItem = [CCMenuItemImage itemFromNormalImage:@"resume-ipad.png" selectedImage:@"resume-ipad.png" target:self selector:@selector(resumeGame:)];
            
            [playagainItem setPosition:ccp(winSize.width*0.25, winSize.height*0.40)];
            
            mmItem = [CCMenuItemImage itemFromNormalImage:@"mainmenu-ipad.png" selectedImage:@"mainmenu-ipad.png" target:self selector:@selector(exitToMainMenu:)];
            
            [mmItem setPosition:ccp(winSize.width*0.25, winSize.height*0.29)];
        }
        else {
            return nil;
        }
        
        CCMenu *menu = [CCMenu menuWithItems:mmItem, playagainItem, nil];
        [menu setPosition: ccp(0, 0)];
        
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
	gGameShouldRestart = TRUE;
	[[CCDirector sharedDirector] popScene];
}

- (void) exitToMainMenu: (id) sender
{
	gGameSuspended = FALSE;
	gGameShouldEndAndRetun = TRUE;
	
	[[CCDirector sharedDirector] popScene];
}

+ (CCMenuItemFont *) getSpacerItem
{
	[CCMenuItemFont setFontSize:2];
	return [CCMenuItemFont itemFromString:@" " target:self selector:nil];
}

@end
