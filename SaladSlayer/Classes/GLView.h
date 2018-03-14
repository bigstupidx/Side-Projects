//
//  GLView.h
//

#import <UIKit/UIKit.h>
#import "GLViewController.h"
#import "OpenGLES2DView.h"
#import "Constants.h"
#import "Sword.h"
#import "Fruit.h"
#import "Sprite.h"
#import "Audio.h"
#import "Texture2D.h"//;
#import "Atlas.h"
#import "ParticleAtlas.h"
#import "Game.h"
#import "OptionsViewController.h"
//#import "GameKitLibrary.h"
#import "FruitSlayerAppDelegate.h"
#import "GADBannerView.h"
#import "SHKSharer.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"

#import "MemoryConsumer.h"

#import "Pineapple.h"
#import "Banana.h"
#import "Kiwi.h"
#import "Lemon.h"
#import "Mango.h"
#import "RedApple.h"
#import "GreenApple.h"
#import "Coconut.h"
#import "Pear.h"
#import "Melon.h"
#import "Orange.h"
#import "Poison.h"
#import "Coin.h"
#import "Clock.h"

@class GLViewController;
@class Sword;
@class Fruit;
@class Sprite;
@class Audio;
@class Texture2D;
@class Atlas;
@class ParticleAtlas;
@class Game;
@class OptionsViewController;
@class FruitSlayerAppDelegate;
@class MemoryConsumer;

@interface GLView : OpenGLES2DView <UIAccelerometerDelegate> {
	//Parent
	GLViewController *parent;
	
	//Controls
	UILabel *overlayLabel;
	UIImageView *pausePanel;
	UIButton *resumeButton;
	UIButton *restartButton;
	UIButton *optionsButton;
	UIButton *quitButton;
	UIButton *pauseButton;
	UIButton *retryButton;
	UIButton *scoresButton;
	UIButton *twitterButton;
	UIButton *facebookButton;
	UIImageView *gameOverImage;
	UIImageView *gameLogo;
	UIImageView *newHighScore;
	
	//Flags
	bool texturesLoaded;
	bool objectsLoaded;
	GADBannerView *bannerView_;
	//Textures
	Texture2D *background;
	NSMutableArray *swordTextures;
	GLuint fruitsTexture;
	Atlas *spritesAtlas;
	ParticleAtlas *particlesAtlas;
	
	//Drawing
	BOOL displayLinkSupported;
	id displayLink;
	NSTimer *timerScene;
	bool animating;

	//FPS
	int calculatedFPS;
	CFTimeInterval timeFPS;
	
	//Game
	Game *mainGame;
}

#pragma mark Properties

@property (nonatomic, assign) GLViewController *parent;
@property (nonatomic, assign) Game *mainGame;
@property (nonatomic) bool texturesLoaded, objectsLoaded, animating;

#pragma mark Initialization

- (void)initializeObjects: (GLViewController*) p;

-(void) initializeUIKit;

-(void) loadTextures;

-(void) unloadTextures;

-(void) resetAll;

#pragma mark Animation UIKit

-(void) resetControls;

-(void) animateControlsIn;

-(void) animateControlsOut;

-(void) animateGameOverIn;

-(void) animateGameOverOut;

#pragma mark Animation OpenGLES

-(void) startAnimation;

-(void) stopAnimation;

-(void) drawScene;

#pragma mark Drawing

-(void) drawFrame;

-(void) drawBackground;

-(void) draw3DFruits;

-(void) drawSwords;

-(void) drawBottomSprites;

-(void) drawParticles;

-(void) drawTopSprites;

-(void) drawHUD;

-(void) drawNumber: (int) label Font: (int) fontno PosX: (float) x PosY: (float) y Size: (float) size Spacing: (float) spacing Alpha: (float) alpha Center: (bool) center;

#pragma mark UI Events

-(void) pauseClick;

-(void) resumeClick;

-(void) restartClick;

-(void) optionsClick;

-(void) quitClick;

-(void) scoresClick;

#pragma mark Other events

-(void) pauseGame;

-(void) resumeGame;

-(void) restartGame;

-(void) gameOver;

#pragma mark Facebook/Twitter/Email share

-(void)broadcastToTwitter;

-(void)broadcastToFacebook;

-(NSString *) textToBroadcast;

@end