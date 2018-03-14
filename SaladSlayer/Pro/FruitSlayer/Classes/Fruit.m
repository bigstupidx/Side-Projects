//
//  Fruit.m
//

#import "Fruit.h"

@implementation Fruit

@synthesize active, juicy, sliced, type, frames, posX, posY, speedX, speedY, rotation, speedRotation,
	alpha, size, oldCoords, vectorX, vectorY, vectorZ, scale, radius, lucky;

-(id) initPosX: (float) x PosY: (float) y SpeedX: (float) sx SpeedY: (float) sy Type: (int) t Lucky: (bool) l{
	if (self = [super init]) {
		//Initiate properties
		active = TRUE;
		type = t;
		sliced = FALSE;
		frames = 0;
		posX = x;
		posY = y;
		speedX = sx;
		speedY = sy;
		rotation = 0;
		speedRotation = 0;
		alpha = 1;
		size = 1;
		lucky = l;
		
		//Normal scale
		scale = type == 10 || type == 11 || type == 12 ? 0.70 : type == 20 || type == 21 || type == 22  ? 0.55 : type == 30 || type == 31 || type == 32  ? 0.50 : type == 40 || type == 41 || type == 42  ? 0.50 : type == 50 || type == 51 || type == 52  ? 0.82 : type == 60 || type == 61 || type == 62  ? 0.6 : type == 70 || type == 71 || type == 72  ? 0.6 : type == 80 || type == 81 || type == 82  ? 0.85 : type == 90 || type == 91 || type == 92  ? 0.5 : type == 100 || type == 101 || type == 102  ? 0.5 : type == 110 || type == 111 || type == 112 ? 0.6 : type == 120 ? 0.45 : type == 130 ? 0.45 : type == 140 ? 0.45 : 0;
		
		//Scale up a bit
		scale = scale * 1.25;
		
		//Radius
		radius = type == 10 || type == 11 || type == 12 ? 50 : type == 20 || type == 21 || type == 22  ? 50 : type == 30 || type == 31 || type == 32  ? 25 : type == 40 || type == 41 || type == 42  ? 30 : type == 50 || type == 51 || type == 52  ? 32 : type == 60 || type == 61 || type == 62  ? 25 : type == 70 || type == 71 || type == 72  ? 25 : type == 80 || type == 81 || type == 82  ? 35 : type == 90 || type == 91 || type == 92  ? 30 : type == 100 || type == 101 || type == 102  ? 45 :  type == 110 || type == 111 || type == 112 ? 25 : type == 120 ? 30 : type == 130 ? 30 : type == 140 ? 30 : 0;
		
		//Juicy
		juicy = type == 20 || type == 120 || type == 130 || type == 140 ? FALSE : TRUE;
		
		//Rotation vector
		vectorX = ((float) (rand() % 100)) / 100.0f;
		vectorY = ((float) (rand() % 100)) / 100.0f;
		vectorZ = ((float) (rand() % 100)) / 100.0f;
		
		//Special bomb rotation vector
		if (type == 140) {
			vectorZ = 1;
			vectorY = 1;
			vectorX = 0;
		}
		
		//Initiate old collection
		oldCoords = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void) newFrame {
	//Frame increment
	frames++;
	
	//Store old position
	if (frames % 2 == 0) {
		Coord *c = [[Coord alloc] initPosX: posX PosY: posY];
		[oldCoords insertObject: c atIndex: [oldCoords count]];
		[c release];
	}
		
	//Maximum 5 old positions
	if ([oldCoords count] > 5)
		[oldCoords removeObjectAtIndex: 0];
	
	//Rotation
	rotation += speedRotation;
	if (rotation >= 360)
		rotation -= 360;
	
	//Movement
	posX += speedX;
	posY += speedY;
	
	//Falldown speed depending on type and direction
	if (type == 140) {
		if (speedY >= 0)
			speedY -= 0.15;
		else
			speedY -= 0.35;		
	} else if (type % 10 == 0) {
		if (speedY >= 0)
			speedY -= 0.15;
		else
			speedY -= 0.20;
	} else {
		if (speedY >= 0)
			speedY -= 0.15;
		else
			speedY -= 0.30;
	}
	
	//Deactivate
	if (posY < -screenHeight/8 && speedY < 0)
		active = FALSE;
}

-(void) playSplashSound {		
	//Play random sound
	if (self.type < 120) {
		int snd = rand() % 100;
		if (snd <= 33)
			[[Audio sharedAudio] playSound: @"splat1"];
		else if (snd <= 66)
			[[Audio sharedAudio] playSound: @"splat2"];
		else
			[[Audio sharedAudio] playSound: @"splat3"];
	} else if (self.type == 120) {
		//No sound
	} else if (self.type == 130) {
		//No sound
	} else if (self.type == 140) {
		[[Audio sharedAudio] playSound: @"bottle"];
	}
}

#pragma mark Memory managemenet

-(void) dealloc {
	//Release
	[oldCoords removeAllObjects];
	[oldCoords release];
	oldCoords = nil;

	//Super
	[super dealloc];
}

@end
