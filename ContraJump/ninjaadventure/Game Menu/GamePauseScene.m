#import "GamePauseScene.h"
#import "Globals.h"
#import "AdsManager.h"
#import "GameMenu.h"

@implementation GamePauseScene

- (id) init
{
	self = [super init];
    
	if (self)
	{
        CCMenu * myMenu;
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage: @"btn_pause_resume.png"
                                                             selectedImage: @"btn_pause_resume_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(resumeGame:)];
        myMenu = [CCMenu menuWithItems:menuItem1, nil];
        myMenu.position = ccp(110, 250);
        [self addChild:myMenu z:3];
        
        CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage: @"btn_pause_mainmenu.png"
                                                             selectedImage: @"btn_pause_mainmenu_Chosen.png"
                                                                    target:self
                                                                  selector:@selector(exitToMainMenu:)];
        
        
        myMenu = [CCMenu menuWithItems:menuItem2, nil];
        myMenu.position = ccp(230, 250);
        [self addChild:myMenu z:3];
	}
	return self;
}

- (void) dealloc
{
	//[super dealloc];
}

- (void) resumeGame: (id) sender
{
    //[[AdsManager sharedAdsManager] showAdOnPause];
	gGameSuspended = FALSE;
	[[CCDirector sharedDirector] popScene];
}

- (void) exitToMainMenu: (id) sender
{
    [[AdsManager sharedAdsManager] showAdOnPause];
	[[CCDirector sharedDirector] replaceScene:[GameMenu scene]];
}


@end
