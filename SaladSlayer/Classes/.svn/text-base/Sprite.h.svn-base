//
//  Sprite.h
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Audio.h"

@class Audio;

@interface Sprite : NSObject {
	bool active, gravity;
	int type, model, frames;
	float posX, posY, speedX, speedY, rotation, speedRotation, alpha, size;
}

@property (nonatomic) bool active, gravity;
@property (nonatomic) int type, model, frames;
@property (nonatomic) float posX, posY, speedX, speedY, rotation, speedRotation, alpha, size;

-(id) initPosX: (float) x PosY: (float) y SpeedX: (float) sx SpeedY: (float) sy Type: (int) t;

-(void) newFrame;

-(void) newFrameSplat;

-(void) newFrameDrop;

-(void) newFrameStar;

-(void) newFrameMissed;

-(void) newFrameBanner;

-(void) newFrameBonusStar;

-(void) newFrameSmoke;

-(void) newFrameStriketrough;

@end
