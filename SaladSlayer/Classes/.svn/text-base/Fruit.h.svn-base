//
//  Fruit.h
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Audio.h"
#import "GLView.h"
#import "Game.h"

@class Audio;
@class GLView;
@class Game;

@interface Fruit : NSObject {
	bool active, juicy, sliced, lucky;
	int type, frames;
	float posX, posY, speedX, speedY, rotation, speedRotation, alpha, size, vectorX, vectorY, vectorZ, radius;
	GLfloat scale;
	NSMutableArray *oldCoords;
}

#pragma mark Properties

@property (nonatomic) bool active, juicy, sliced, lucky;
@property (nonatomic) int type, frames;
@property (nonatomic) float posX, posY, speedX, speedY, rotation, speedRotation, alpha, size, vectorX, vectorY, vectorZ, radius;
@property (nonatomic) GLfloat scale;
@property (nonatomic, retain) NSMutableArray *oldCoords;

#pragma mark Methods

-(id) initPosX: (float) x PosY: (float) y SpeedX: (float) sx SpeedY: (float) sy Type: (int) t Lucky: (bool) l;

-(void) newFrame;

-(void) playSplashSound;

@end
