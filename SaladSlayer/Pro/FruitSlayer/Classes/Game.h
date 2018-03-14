//
//  Game.h
//

#import <Foundation/Foundation.h>
#import "Sword.h"
#import "Fruit.h"
#import "Sprite.h"
#import "GameKitLibrary.h"

@class Sword;
@class Fruit;
@class Sprite;
@class GameKitLibrary;

@interface Game : NSObject {
	//Game objects
	NSMutableArray *swords;
	NSMutableArray *fruits;
	NSMutableArray *sprites;
	NSMutableArray *particles;
	
	//Level generator
	int nextFruitFrame;
	int currentWaveCount;
	int currentNonBombCount;
	
	//Game state
	bool active;
	
	//Device performance
	bool highPerformance;
	
	//Other
	int currentFrame, mode, score, lives, sword, slicedCount, slicedFrames, countdownTime, doubleFrames, comboPower;

}

@property (nonatomic, retain) NSMutableArray *swords;
@property (nonatomic, retain) NSMutableArray *fruits;
@property (nonatomic, retain) NSMutableArray *sprites;
@property (nonatomic, retain) NSMutableArray *particles;

@property (nonatomic) bool active, highPerformance;
@property (nonatomic) int currentFrame, mode, score, lives, sword, countdownTime, doubleFrames, comboPower;
@property (nonatomic, readonly) int scoreMultiplier;

#pragma mark Initialization

-(id) initGame;

-(void) resetGame;

#pragma mark Game calculation

-(void) calculateFrame;

#pragma mark Events

-(void) checkEndOfGame;

-(void) checkCombo;

-(void) checkCollisions;

-(void) performCountdown;

-(void) lostNormalFruit: (Fruit *) fr;

-(void) incrementSliceCount;

-(void) cutNormalFruit: (Fruit *) fr withSword: (Sword *) sw;

-(void) cutLuckyFruit: (Fruit *) fr withSword: (Sword *) sw;

-(void) cutPoisonBottle: (Fruit *) fr withSword: (Sword *) sw;

-(void) showBanner: (int) identifier;

-(void) createLevel;

-(void) createNewFruitType: (int) type Lucky: (bool) l;

-(void) createSwordStars;

#pragma mark Utilities

-(int) getAvailableBannerPosition;

@end