//
//  Sprite.m
//
// 1 = splat; 2 = drop; 3 = star; 4 = missed; 5 = banner; 6 = bonus-star; 7 = smoke; 8 - striketrought
//

#import "Sprite.h"

@implementation Sprite

@synthesize active, gravity, type, model, frames, posX, posY, speedX, speedY, rotation, speedRotation, alpha, size;

-(id) initPosX: (float) x PosY: (float) y SpeedX: (float) sx SpeedY: (float) sy Type: (int) t {
	if (self = [super init]) {
		active = TRUE;
		gravity = TRUE;
		type = t;
		model = 0;
		frames = 0;
		posX = x;
		posY = y;
		speedX = sx;
		speedY = sy;
		rotation = 0;
		speedRotation = 0;
		alpha = 1;
		size = 1;
	}
	
	return self;
}

-(void) newFrame {
	//Frames
	frames++;
	
	//Movement
	posX += speedX;
	posY += speedY;
	
	//Rotation
	rotation += speedRotation;

	//Custom actions
	if (type == 1)
		[self newFrameSplat];
	else if (type == 2)
		[self newFrameDrop];
	else if (type == 3)
		[self newFrameStar];
	else if (type == 4)
		[self newFrameMissed];
	else if (type == 5)
		[self newFrameBanner];
	else if (type == 6)
		[self newFrameBonusStar];
	else if (type == 7)
		[self newFrameSmoke];
	else if (type == 8)
		[self newFrameStriketrough];
}

-(void) newFrameSplat {
	//Drip down
	if (frames > 120) {
		alpha = 0.5f - (float)(frames - 120) / 60.0f;
	}
	
	//Deactivation
	if (frames > 180)
		active = FALSE;
}

-(void) newFrameDrop {
	//Size
	size -= 0.01;
	
	//Falldown speed
	if (gravity)
		speedY -= 0.1;
	else
		speedY -= 0.03;
	
	//Deactivation
	if (size < 0.1 || posX < 0 || posX > screenWidth || posY < 0 || posY > screenHeight)
		active = FALSE;	
}

-(void) newFrameStar {
	//Slow down
	speedX = speedX * 0.95;
	speedY = speedY * 0.95;
	
	//Size
	size -= 0.02;
	
	//Alpha
	alpha -= 0.02;
	
	//Deactivation
	if (size < 0.1 || posX < 0 || posX > screenWidth || posY < 0 || posY > screenHeight)
		active = FALSE;
}

-(void) newFrameMissed {
	//Fade in
	if (frames < 10) {
		alpha = (float)(frames) / 10.0f;
		size = 1.0f + (float)(10 - frames) / 10.0f;
	} else if (frames >= 10 && frames < 60) {
		alpha = 1.0f;
		size = 1.0f;
	} else if (frames >= 60) {
		alpha = 1.0f - (float)(frames - 60) / 30.0f;
		size = 1.0f;
	}
	
	//Deactivation
	if (frames > 90)
		active = FALSE;
}

-(void) newFrameBanner {
	//Fade in
	if (frames < 10) {
		alpha = (float)(frames) / 10.0f;
		size = 1.0f + (float)(10 - frames) / 10.0f;
	} else if (frames >= 10 && frames < 60) {
		alpha = 1.0f;
		size = 1.0f;
	} else if (frames >= 60) {
		alpha = 1.0f - (float)(frames - 60) / 10.0f;
		size = 1.0 + (float)(frames - 60) / 10.0f;
	}
	
	//Deactivation
	if (frames > 70)
		active = FALSE;
}

-(void) newFrameBonusStar {
	//Slow down
	speedX = speedX * 0.97;
	speedY = speedY * 0.97;
	
	//Size
	size -= 0.02;
	
	//Alpha
	alpha -= 0.02;
	
	//Deactivation
	if (size < 0.1 || alpha < 0.1)
		active = FALSE;
}

-(void) newFrameSmoke {
	//Size
	size += 0.02;
	
	//Alpha
	if (size > 0.75)
		alpha -= 0.025;
	
	//Deactivation
	if (alpha <= 0.0)
		active = FALSE;
}

-(void) newFrameStriketrough {
	//Deactivation
	if (self.frames > 5)
		active = FALSE;
}

@end
