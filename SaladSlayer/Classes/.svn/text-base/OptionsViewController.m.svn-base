//
//  OptionsViewController.m
//

#import "OptionsViewController.h"

@implementation OptionsViewController

#pragma mark Load/FadeIn/FadeOut

-(void) viewDidLoad {
	//Set initial setting
	[btnSFX setImage: [UIImage imageNamed: [Audio sharedAudio].sfxSetting ? @"btnSfxOn.png" : @"btnSfxOff.png"] forState:UIControlStateNormal]; 
	[btnMusic setImage: [UIImage imageNamed: [Audio sharedAudio].musicSetting ? @"btnMusicOn.png" : @"btnMusicOff.png"] forState:UIControlStateNormal];		
	
	//Full/Free
	[imgLogo setImage: isFullGame ? [UIImage imageNamed: @"imgLogo.png"] : [UIImage imageNamed: @"imgLogoLite.png"]];
	
	//Reset
	[super viewDidLoad];
}

#pragma mark UI Events

-(void) toogleSFX {	
	//Invert current state
	bool currentState = ![Audio sharedAudio].sfxSetting;
	
	//Apply
	[[Audio sharedAudio] setSFXSetting: currentState];
	[btnSFX setImage: [UIImage imageNamed: currentState ? @"btnSfxOn.png" : @"btnSfxOff.png"] forState:UIControlStateNormal]; 

	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
}
 
-(void) toogleMusic {
	//Invert current state
	bool currentState = ![Audio sharedAudio].musicSetting;
	
	//Apply
	[[Audio sharedAudio] setMusicSetting: currentState];
	[btnMusic setImage: [UIImage imageNamed: currentState ? @"btnMusicOn.png" : @"btnMusicOff.png"] forState:UIControlStateNormal];
	
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Play music
	if (currentState)
		[[Audio sharedAudio] playMusic: @"rainforest" Loop: TRUE];
}
 
-(void) showCustomize {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Present customize controller
	CustomizeViewController *cvc = [[[CustomizeViewController alloc] initWithNibName: @"CustomizeViewController" bundle: nil] autorelease];
	[self presentFadingViewController: cvc];
}

-(void) back {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Dismiss
	[self dismissFadingViewController];
}

#pragma mark OS Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark Memory management

-(void) dealloc {
	NSLog(@"Options deallocated");
	
	//Release outlets
	[imgBackground release];
	[imgLogo release];
	[imgSwords release];
	[imgPanel release];
	[btnSFX release];
	[btnMusic release];
	[btnCustomize release];
	[btnBack release];
	
	//Super
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end