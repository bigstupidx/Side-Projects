//
//  Game.m
//

#import "Game.h"

@implementation Game

@synthesize swords, fruits, sprites, particles, currentFrame, mode, score, lives, sword, active, countdownTime, doubleFrames, comboPower, highPerformance;

#pragma mark Initialization

-(id) initGame {
	if (self = [super init]) {		
		//Initiate collections
		swords = [[NSMutableArray alloc] init];
		fruits = [[NSMutableArray alloc] init];
		sprites = [[NSMutableArray alloc] init];
		particles = [[NSMutableArray alloc] init];
		
		//Defaults
		mode = 0;
		sword = 0;
		
		//Reset
		[self resetGame];
	}
	
	return self;
}

-(void) resetGame {
	//Reset collections
	[swords removeAllObjects];
	[fruits removeAllObjects];
	[sprites removeAllObjects];
	[particles removeAllObjects];
	
	//Level generator
	nextFruitFrame = 0;
	currentWaveCount = 0;
	currentNonBombCount = 0;
	
	//Reset other vars
	currentFrame = 0;
	score = 0;
	lives = 3;
	active = TRUE;

	//Reset countdown time acording to game mode
	if (mode == 1)
		countdownTime = 60;
	else if (mode == 2)
		countdownTime = 90;
	doubleFrames = 0;
	
	//Combo checker
	slicedCount = 0;
	slicedFrames = 0;
	comboPower = 0;
	
	//Device performance detection
	highPerformance = ((FruitSlayerAppDelegate *) [UIApplication sharedApplication].delegate).highPerformance;
}

#pragma mark Game calculations

-(void) calculateFrame {
	//Update all object in the main game loop
	
	//Swords
	int i = 0;
	while (i<[swords count]) {
		Sword *s = [swords objectAtIndex: i];
		
		//New frame
		[s newFrame];
		
		//Deactivation
		if (!s.active)
			[swords removeObjectAtIndex: i];
		else
			i++;
	}
	
	//Fruits
	i = 0;
	while (i<[fruits count]) {
		Fruit *f = [fruits objectAtIndex: i];
		
		//New frame
		[f newFrame];
		
		//Lost fruits
		if (self.active && !f.active && !f.sliced && f.type < 120 && f.type % 10 == 0)
			[self lostNormalFruit: f];
		
		//Deactivation
		if (!f.active)
			[fruits removeObjectAtIndex: i];
		else
			i++;
	}
	
	//Sprites
	i = 0;
	while (i<[sprites count]) {
		Sprite *s = [sprites objectAtIndex: i];
		
		//New frame
		[s newFrame];
		
		//Deactivation
		if (!s.active)
			[sprites removeObjectAtIndex: i];
		else
			i++;
	}
	
	//Particles
	i = 0;
	while (i<[particles count]) {
		Sprite *s = [particles objectAtIndex: i];
		
		//New frame
		[s newFrame];
		
		//Deactivation
		if (!s.active)
			[particles removeObjectAtIndex: i];
		else
			i++;
	}
	
	//End of game
	[self checkEndOfGame];
	
	//Check combo
	[self checkCombo];
	
	//Check collisions
	[self checkCollisions];
	
	//Create new stars
	[self createSwordStars];
	
	//Perform time countdown
	[self performCountdown];
	
	//Create new fruits
	[self createLevel];
	
	//Increment frame
	currentFrame++;
}

-(void) checkEndOfGame {
	if (!active)
		return;
	
	//End of game condition
	if ((mode == 0 && lives == 0) || (mode == 1 && countdownTime == 0) || (mode == 2 && countdownTime == 0)) {		
		//Deactivate game
		active = FALSE;
		
		//Play gong sound
		[[Audio sharedAudio] playSound: @"gong"];
	}
}

-(void) checkCombo {
	if (!active)
		return;
	
	//Combo checker
	if (slicedFrames > 0) {
		//Decrement frames
		slicedFrames--;
		
		//Win combo
		if (slicedFrames == 0 && slicedCount > 2) {
			//Show banner
			[self showBanner: slicedCount];
			
			//Add combo points
			self.score += slicedCount * self.scoreMultiplier;
			
			//Increment combo power
			self.comboPower += slicedCount * self.scoreMultiplier;
		}
	}
	
	//Combo power decrement
	if (currentFrame % 120 == 0 && self.comboPower > 0)
		self.comboPower--;
}

-(void) checkCollisions {
	//For each sword
	for (int p=0; p<[swords count]; p++) {
		Sword *sw = [swords objectAtIndex: p];
		
		//Check sword speed
		if (sw.vectorSpeed > 5) {
			
			//For each fruit
			for (int k=0; k<[fruits count]; k++) {
				Fruit *fr = [fruits objectAtIndex: k];
				
				//Skip inactive or half-fruits
				if (fr.active && fr.type % 10 == 0) {
					//Calculate hit range
					float hitRange = fr.radius + sw.radius * 1.5;
					
					//Hit check 1
					bool wasHit = [Geometry getPolarVectorDX: sw.posX-fr.posX DY: sw.posY-fr.posY] < hitRange;
					
					//Hit check 2
					if (!wasHit && [sw.coords count] > 1) {
						Coord *swordCoord1 = [sw.coords objectAtIndex: [sw.coords count]-2];
						wasHit = [Geometry getPolarVectorDX: swordCoord1.posX-fr.posX DY: swordCoord1.posY-fr.posY] < hitRange;
						
						//Hit check 3
						if (!wasHit && [sw.coords count] > 3) {
							Coord *swordCoord2 = [sw.coords objectAtIndex: [sw.coords count]-4];
							wasHit = [Geometry getPolarVectorDX: swordCoord2.posX-fr.posX DY: swordCoord2.posY-fr.posY] < hitRange;
							
							//Hit check 4
							if (!wasHit && [sw.coords count] > 5) {
								Coord *swordCoord3 = [sw.coords objectAtIndex: [sw.coords count]-6];
								wasHit = [Geometry getPolarVectorDX: swordCoord3.posX-fr.posX DY: swordCoord3.posY-fr.posY] < hitRange;
							}
						}
					}
					
					//Take action if fruit was hit
					if (wasHit) {
						//Deactivation by slicing
						fr.active = FALSE;
						fr.sliced = TRUE;
						
						//Perform specific cut action
						if (fr.lucky)
							[self cutLuckyFruit: fr withSword: sw];
						else if (fr.type == 140)
							[self cutPoisonBottle: fr withSword: sw];
						else
							[self cutNormalFruit: fr withSword: sw];
					}
				}
			}
		}
	}
}

#pragma mark Game events

-(void) performCountdown {
	if (!active)
		return;
	
	//Arcade time
	if (mode == 1 || mode == 2) {
		//Clock tick
		if (currentFrame % 30 == 0 && countdownTime > 0 && countdownTime <= 10)
			[[Audio sharedAudio] playSound: @"clocktick"];			
			
		if (currentFrame % 60 == 0 && countdownTime > 0) {
			//Decrement arcade time
			countdownTime--;
		}
		
		//Normalize time (0..90)
		if (countdownTime > 90)
			countdownTime = 90;
		else if (countdownTime < 0)
			countdownTime = 0;
	}
	
	//Double points decrement
	if (doubleFrames > 0)
		doubleFrames--;
}

-(void) lostNormalFruit: (Fruit *) fr {
	if (!active)
		return;
	
	//Apply damage
	if (self.mode == 0) {
		self.lives--;
		
		//Normalize
		if (self.lives < 0)
			self.lives = 0;
	} else if (self.mode == 1) {
		self.score--;
		
		//Normalize
		if (self.score < 0)
			self.score = 0;
	}
	
	if (self.mode == 0 || self.mode == 1) {
		//Create sprite
		Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: 23 SpeedX:0 SpeedY:0 Type:4];
		[self.sprites insertObject: s atIndex: [sprites count]];
		[s release];
		
		//Play sound
		[[Audio sharedAudio] playSound: @"missed"];
	}
}

-(void) incrementSliceCount {
	//Increment sword slice count
	if (slicedFrames == 0)
		slicedCount = 1;
	else
		slicedCount++;
	slicedFrames = 8;
}

-(void) cutNormalFruit: (Fruit *) fr withSword: (Sword *) sw {	
	//Increment slice count
	[self incrementSliceCount];
		
	//Increment score
	score += 1 * self.scoreMultiplier;
	
	//Play splash sound
	[fr playSplashSound];
	
	//Create splatter and drops
	if (fr.juicy && highPerformance) {
		//Create splatter
		Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: fr.posY SpeedX: 0 SpeedY: 0 Type: 1];
		s.model = fr.type / 10;
		s.alpha = 0.5;
		s.rotation = rand() % 360;
		s.size = 0.75f + (float) (rand() % 50) / 100.0f;
		[sprites insertObject: s atIndex: [sprites count]];
		[s release];
		
		//Create small drops
		float currentUngle = sw.vectorUngle;
		float targetUngle = sw.vectorUngle + 360;
		do {
			//Calculate speeds
			float sp = 2.0f + (float) (rand() % 15) / 10.0f;
			float sx = sp * cos([Geometry deg2Rad: currentUngle]);
			float sy = sp * sin([Geometry deg2Rad: currentUngle]);
			
			//Add sword direction
			sx += cos([Geometry deg2Rad: sw.vectorUngle]);
			sy += sin([Geometry deg2Rad: sw.vectorUngle]);
			
			//Create drop
			Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: fr.posY SpeedX: sx SpeedY: sy Type: 2];
			s.model = fr.type/10;
			s.rotation = rand() % 360;
			s.size = 0.40f;
			s.gravity = FALSE;
			[particles insertObject: s atIndex: [particles count]];
			[s release];
			
			//Increment ungle
			currentUngle += 10 + rand() % 10;
		} while (currentUngle < targetUngle);
		
		//Big drops
		currentUngle = sw.vectorUngle + 360 - 90;
		targetUngle = sw.vectorUngle + 360 + 90;
		do {
			//Calculate speeds
			float sp = 1.5f + (float) (rand() % 15) / 10.0f;
			float sx = sp * cos([Geometry deg2Rad: currentUngle]);
			float sy = sp * sin([Geometry deg2Rad: currentUngle]);
			
			//Add sword direction
			sx += cos([Geometry deg2Rad: sw.vectorUngle]);
			sy += sin([Geometry deg2Rad: sw.vectorUngle]);
			
			//Create drop
			Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: fr.posY SpeedX: sx SpeedY: sy Type: 2];
			s.model = fr.type/10;
			s.rotation = rand() % 360;
			s.size = 0.70f;
			s.gravity = TRUE;
			[particles insertObject: s atIndex: [particles count]];
			[s release];
			
			//Increment ungle
			currentUngle += 10 + rand() % 30;
		} while (currentUngle < targetUngle);
	}
	
	//Create half fruits
	if (TRUE) {
		float sx = fr.speedX / 2.0f + 1.5f * cos([Geometry deg2Rad: fr.rotation+180]);
		float sy = fr.speedY / 2.0f + 1.5f * sin([Geometry deg2Rad: fr.rotation+180]);
		
		//Insert fruit
		Fruit *fh = [[Fruit alloc] initPosX: fr.posX PosY: fr.posY SpeedX:sx SpeedY: sy Type: fr.type + 1 Lucky: FALSE];
		fh.speedRotation = fr.type == 10 || fr.type == 20 ? fr.speedRotation / 2 : fr.speedRotation * 1.5;
		fh.rotation = fr.rotation;
		fh.vectorX = fr.vectorX;
		fh.vectorY = fr.vectorY;
		fh.vectorZ = fr.vectorZ;
		[fruits insertObject: fh atIndex: [fruits count]];
		[fh release];
	}
	
	//Create half fruits
	if (TRUE) {
		float sx = fr.speedX / 2.0f + 1.5f * cos([Geometry deg2Rad: fr.rotation]);
		float sy = fr.speedY / 2.0f + 1.5f * sin([Geometry deg2Rad: fr.rotation]);
		
		//Insert fruit
		Fruit *fh = [[Fruit alloc] initPosX: fr.posX PosY: fr.posY SpeedX:sx SpeedY: sy Type: fr.type + 2 Lucky: FALSE];
		fh.speedRotation = fr.type == 10 || fr.type == 20 ? fr.speedRotation / 2 : fr.speedRotation * 1.5;
		fh.rotation = fr.rotation;
		fh.vectorX = fr.vectorX;
		fh.vectorY = fr.vectorY;
		fh.vectorZ = fr.vectorZ;
		[fruits insertObject: fh atIndex: [fruits count]];
		[fh release];
	}
	
	//Create strikethrough
	Sprite *s = [[Sprite alloc] initPosX: sw.posX PosY: sw.posY SpeedX: 0 SpeedY: 0 Type: 8];
	s.rotation = sw.vectorUngle;
	[sprites insertObject: s atIndex: [sprites count]];
	[s release];
}

-(void) cutLuckyFruit: (Fruit *) fr withSword: (Sword *) sw {
	if (fr.type < 110) {
		//Increment slice count only for lucky fruits
		[self incrementSliceCount];
		
		//Lucky fruit
		self.score += 10 * self.scoreMultiplier;
		
		//Banner
		[self showBanner: 1];
	} else if (fr.type == 120) {
		//Double points
		self.doubleFrames += 600;
		
		//Banner
		[self showBanner: 7];
	} else if (fr.type == 130) {
		//Extra time
		self.countdownTime += 10 * self.scoreMultiplier;
		
		//Re-activate game
		self.active = TRUE;
		
		//Banner
		[self showBanner: 6];
	} 
	
	//Star explosion
	for (int i=0; i<360; i+= 30) {
		//Create speeds
		float sx = 5.0 * cos([Geometry deg2Rad: i]);
		float sy = 5.0 * sin([Geometry deg2Rad: i]);
		
		//Create star particles
		Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: fr.posY SpeedX: sx SpeedY: sy Type: 6];
		s.model = 13;
		[particles insertObject: s atIndex: [particles count]];
		[s release];
	}
}

-(void) cutPoisonBottle: (Fruit *) fr withSword: (Sword *) sw {
	//Glass sound
	[[Audio sharedAudio] playSound: @"bottle"];
	
	//Deactivate any bonuses
	doubleFrames = 0;
	
	//Deactivate combo power
	comboPower = 0;
	
	//Apply damage
	if (self.mode == 0) {
		self.lives--;
		
		//Normalize
		if (self.lives < 0)
			self.lives = 0;
	} else if (self.mode == 1) {
		self.score-=10;
		
		//Normalize
		if (self.score < 0)
			self.score = 0;
	}
	
	//Create green smoke sprite
	if (TRUE) {
		Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: fr.posY SpeedX:0 SpeedY:0 Type:7];
		s.alpha = 1.0;
		s.size = 0.3;
		[self.sprites insertObject: s atIndex: [sprites count]];
		[s release];
	}

	//Create green smoke sprite
	if (TRUE) {
		Sprite *s = [[Sprite alloc] initPosX: fr.posX PosY: fr.posY SpeedX:0 SpeedY:0 Type:7];
		s.alpha = 0.7;
		s.size = 0.5;
		[self.sprites insertObject: s atIndex: [sprites count]];
		[s release];
	}
}

-(void) showBanner: (int) identifier {
	if (!active)
		return;
	
	//Create sprite
	Sprite *s = [[Sprite alloc] initPosX: screenWidth/2 PosY: [self getAvailableBannerPosition] SpeedX:0 SpeedY:0 Type:5];
	s.model = identifier;
	s.alpha = 0;
	[self.sprites insertObject: s atIndex: [sprites count]];
	[s release];
	
	//Play special sound
	if (identifier == 1)
		[[Audio sharedAudio] playSound: @"bonus"];
	else if (identifier == 2)
		[[Audio sharedAudio] playSound: @"bonus"];
	else if (identifier == 3)
		[[Audio sharedAudio] playSound: @"combo"];
	else if (identifier == 4)
		[[Audio sharedAudio] playSound: @"supercombo"];
	else if (identifier == 5)
		[[Audio sharedAudio] playSound: @"supercombo"];
	else if (identifier == 6)
		[[Audio sharedAudio] playSound: @"bonus"];
	else if (identifier == 7)
		[[Audio sharedAudio] playSound: @"bonus"];
}

-(void) createLevel {
	if (!active)
		return;
		
	//Create new fruit moment
	if (currentFrame >= nextFruitFrame) {		
		//Init
		int maximumNonBombFruits = 10;
		int maximumWaveFruits = 0;
		
		//Wave size acording to game mode
		if (mode == 0)
			maximumWaveFruits = 1 + currentFrame / (5 * 60);
		else if (mode == 1)
			maximumWaveFruits = 3 + currentFrame / (5 * 60);
		else if (mode == 2)
			maximumWaveFruits = 2 + currentFrame / (5 * 60);
		
		//Normalize
		if (maximumWaveFruits > 6)
			maximumWaveFruits = 6;
		
		//Waves
		if (currentWaveCount == 0) {
			//Big lag
			nextFruitFrame = currentFrame + 90 + rand() % 30;
			
			//New wave count
			currentWaveCount = maximumWaveFruits;
		} else if (currentWaveCount > 0) {
			//Small lag
			nextFruitFrame = currentFrame + 15 + rand() % 15;
			
			//Wave count decrement
			currentWaveCount--;
		}
				
		//Random type
		int randomType = (1 + rand() % 14) * 10;
		
		//Game modes
		if (mode == 0 || mode == 1) {
			//Classic restriction (no clocks or coins)
			if (mode == 0 && (randomType == 120 || randomType == 130))
				randomType = (1 + rand() % 11) * 10;
			
			//Bomb
			if (randomType == 140) {
				//Reset non bomb count
				currentNonBombCount = 0;
			} else {
				//Increment
				currentNonBombCount++;
				
				//Force bomb on limit
				if (currentNonBombCount >= maximumNonBombFruits) {
					randomType = 140;
					currentNonBombCount = 0;
				}
			}
		} else if (mode == 2) {
			//Normal fruits in zen mode
			randomType = (1 + rand() % 11) * 10;
		}
		
		//Lucky fruits
		bool lucky = FALSE;

		if (randomType <= 110) {
			//Lucky fruit
			if (self.comboPower >= 5) {
				int randomLuck = 1 + rand() % 10;
				if (randomLuck == 5) {
					lucky = TRUE;
					self.comboPower = self.comboPower / 2;
				}
			}
		} else if (randomType == 120 || randomType == 130) {
			//Special object
			if (self.comboPower >= 5) {
				lucky = TRUE;
				self.comboPower = 0;
			} else {
				randomType = (1 + rand() % 11) * 10;
			}
		}
		
		//Create new fruit
		[self createNewFruitType: randomType Lucky: lucky];
	}
}

-(void) createNewFruitType: (int) type Lucky: (bool) l {
	if (!active)
		return;
	
	//PosX
	float posX = 30 + rand() % (screenWidth - 60);
	
	//PosY
	float posY = -screenHeight/4;
	
	//SpeedX
	float speedX =  0.5f + (float)(rand() % 20) / 10.0f;
	speedX = posX < screenWidth / 2 ? speedX : -speedX;
	
	//SpeedY
	float speedY = 9.25f + (float)(rand() % 10) / 10.0f;
	
	//Rotation
	float rotation = 1 + rand() % 5;
	rotation = rand() %  2 == 0 ? rotation : -rotation;
	
	//Create fruit
	Fruit *f = [[Fruit alloc] initPosX: posX PosY: posY SpeedX:speedX SpeedY:speedY Type: type Lucky: l];
	f.speedRotation = rotation;
	[fruits insertObject: f atIndex: [fruits count]];
	[f release];
	
	//Throw sound
	if (type == 140)
		[[Audio sharedAudio] playSound: @"bubbles"];
	else
		[[Audio sharedAudio] playSound: @"throw"];	
}

-(void) createSwordStars {
	if (self.sword == 0)
		return;

	//For each sword
	for (int i=0; i<[swords count]; i++) {
		//Get sword from collection
		Sword *sw = [swords objectAtIndex: i];
		
		//Check sword segments
		if (sw.segmentsAdded < 10)
			continue;
		
		//Create new star
		float starUngle = sw.vectorUngle + 90 + rand() % 180;
		
		//Calculate speeds
		float sx = sw.vectorSpeed / 8 * cos([Geometry deg2Rad: starUngle]);
		float sy = sw.vectorSpeed / 8 * sin([Geometry deg2Rad: starUngle]);
		
		//Create star particle
		Sprite *s = [[Sprite alloc] initPosX: sw.posX PosY: sw.posY SpeedX: sx SpeedY: sy Type: 3];
		s.model = 12;
		[particles insertObject: s atIndex: [particles count]];
		[s release];
		
		//Reset segments added
		sw.segmentsAdded = 0;
	}
}

#pragma mark Utilities

-(int) scoreMultiplier {
	return doubleFrames > 0 ? 2 : 1;
}

-(int) getAvailableBannerPosition {
	bool found;
	int currentHeight = screenHeight - 120;
	
	do {
		//Reset
		found = FALSE;
		
		//Search
		for (int i=0; i<[sprites count]; i++) {
			Sprite *s = [sprites objectAtIndex: i];
			if (s.type == 5 && s.posY == currentHeight) {
				found = TRUE;
				break;
			}
		}
		
		//Decrement height
		currentHeight -= 40;
	} while (found);
	
	return currentHeight + 40;
}

#pragma mark Memory management

-(void)dealloc {
	//Release
	[swords removeAllObjects];
	[swords release];
	swords = nil;
	
	[fruits removeAllObjects];
	[fruits release];
	fruits = nil;
	
	[sprites removeAllObjects];
	[sprites release];
	sprites = nil;
	
	[particles removeAllObjects];
	[particles release];
	particles = nil;
	
	//Debug
	NSLog(@"Game deallocated");
	
	//Super
    [super dealloc];
}

@end