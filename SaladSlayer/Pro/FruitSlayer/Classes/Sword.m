//
//  Sword.m
//

#import "Sword.h"

@implementation Sword

#pragma mark Properties

@synthesize coords, touchID, segmentsAdded, active, posX, posY, tempX, tempY, vectorUngle, vectorSpeed, radius, shouldEnd, verticesCount;

-(GLfloat *)vertices {
    return _vertices;
}

-(GLfloat *)coordinates {
    return _coordinates;
}

#pragma mark Methods

-(id) initWithTouchID: (int) tid CoordX: (float) cx CoordY: (float) cy {
	if (self = [super init]) {
		//Initiate coordinates
		coords = [[NSMutableArray alloc] init];
		
		//Insert first coordinate
		Coord *c = [[Coord alloc] initPosX: cx PosY: cy];
		[coords insertObject: c atIndex: [coords count]];
		[c release];
		
		//Initiate other
		touchID = tid;
		segmentsAdded = 0;
		posX = cx;
		posY = cy;
		lastX = cx;
		lastY = cy;
		tempX = cx;
		tempY = cy;
		active = TRUE;
		shouldEnd = FALSE;
		soundPlayed = FALSE;
		verticesCount = 0;
		radius = 7;
	}
	
	return self;
}

-(void) playRandomSound {
	//At least 15 frame till the sound can be played again
	if (soundFrames > 0)
		return;
	
	//Sound frames
	soundFrames = 15;
	
	//Play random sound
	int snd = rand() % 100;
	if (snd <= 33)
		[[Audio sharedAudio] playSound: @"whoosh1"];
	else if (snd <= 66)
		[[Audio sharedAudio] playSound: @"whoosh2"];
	else
		[[Audio sharedAudio] playSound: @"whoosh3"];
}

-(void) addCoordX:(float) cx CoordY:(float) cy Force: (bool) force {	
	//Update current position
	posX = cx;
	posY = cy;
	
	//Blade backbone point distance
	float distance = [coords count] < 10 ? radius / 2.0 : radius;
	
	//Compare actual distance
	float new_distance = [Geometry getPolarVectorDX: cx-lastX DY: cy-lastY];
	
	if (new_distance < distance) {
		return;
	} else {		
		//Calculate next position
		float newUngle = [Geometry getPolarUngleDX: cx-lastX DY: cy-lastY];
		float newPosX = lastX + distance * cos([Geometry deg2Rad: newUngle]);
		float newPosY = lastY + distance * sin([Geometry deg2Rad: newUngle]);
		
		//Remember as current sword ungle
		vectorUngle = newUngle;
		
		//Add current coordinate to array
		Coord *c = [[Coord alloc] initPosX: newPosX PosY: newPosY];
		[coords insertObject: c atIndex: [coords count]];
		[c release];
		
		//Increment
		segmentsAdded++;
		
		//Remember coordinates
		lastX = newPosX;
		lastY = newPosY;
		
		//Delete tail
		if ([coords count] > 60)
			[coords removeObjectAtIndex: 0];
		
		//Auto start cut
		if ([coords count] > 10)
			shouldEnd = TRUE;
	}
	
	//Recursive call to fill the gaps
	[self addCoordX: cx CoordY: cy Force: FALSE];
}

-(void) endCoords {
	//No longer active
	active = FALSE;
}

-(void) newFrame {
	//Determine sword speed
	vectorSpeed = [Geometry getPolarVectorDX: posX-tempX  DY: posY-tempY];
	
	//Remember tempx and tempy
	tempX = posX; tempY = posY;
	
	//Swoosh sound
	if (vectorSpeed > 30)
		[self playRandomSound];
	
	//Deactivate sound block
	if (soundFrames > 0)
		soundFrames--;

	//Sword must be active and must have at least one coord 
	if (!active || [coords count] == 0)
		return;
	
	//Should end
	if (shouldEnd) {
		//Remove some tail
		for (int i=0; i<2; i++) {
			if ([coords count] > 0)
				[coords removeObjectAtIndex: 0];
		}
		
		//Deactivate if no tail is left
		if ([coords count] == 0) {
			verticesCount = 0;
			soundPlayed = FALSE;
			return;
		}
	}
		
	//Arrow coords
	float x1, x2, x3, x4, y1, y2, y3, y4;

	//Compose vertices
	verticesCount = 0;
	
	//First point on backbone
	Coord *first = [coords objectAtIndex: 0];
	x1 = first.posX; x2 = first.posX; y1 = first.posY; y2 = first.posY;
	
	//Overflow
	if (verticesCount >= 4980)
		return;
	
	//Rest of the points
	if ([coords count] > 1) {
		//For each point on the backbone
		for (int i=0; i<[coords count]-2; i++) {
			//Current and next point
			Coord *current = [coords objectAtIndex: i];
			Coord *next = [coords objectAtIndex: i+1];
			
			//Get ungle
			float ungle = [Geometry getPolarUngleDX: next.posX-current.posX DY: next.posY-current.posY];
			
			//Get size
			float sizeNext = radius * 2 * ((float) (i+1) / (float) [coords count]);
			
			//Next point
			x3 = next.posX + sizeNext * cos([Geometry deg2Rad: ungle + 90]);
			y3 = next.posY + sizeNext * sin([Geometry deg2Rad: ungle + 90]);
			x4 = next.posX + sizeNext * cos([Geometry deg2Rad: ungle - 90]);
			y4 = next.posY + sizeNext * sin([Geometry deg2Rad: ungle - 90]);
			
			//Texture coordinates
			_coordinates[verticesCount + 0] = 0;
			_coordinates[verticesCount + 1] = 0;
			_coordinates[verticesCount + 2] = 1;
			_coordinates[verticesCount + 3] = 0;
			_coordinates[verticesCount + 4] = 1;
			_coordinates[verticesCount + 5] = 1;
	
			//Texture coordinates
			_coordinates[verticesCount + 6] = 1;
			_coordinates[verticesCount + 7] = 1;
			_coordinates[verticesCount + 8] = 0;
			_coordinates[verticesCount + 9] = 0;
			_coordinates[verticesCount + 10] = 0;
			_coordinates[verticesCount + 11] = 1;
			
			//Point vertices
			_vertices[verticesCount + 0] = x1;
			_vertices[verticesCount + 1] = y1;
			_vertices[verticesCount + 2] = x3;
			_vertices[verticesCount + 3] = y3;
			_vertices[verticesCount + 4] = x4;
			_vertices[verticesCount + 5] = y4;
			
			//Point vertices
			_vertices[verticesCount + 6] = x4;
			_vertices[verticesCount + 7] = y4;
			_vertices[verticesCount + 8] = x1;
			_vertices[verticesCount + 9] = y1;
			_vertices[verticesCount + 10] = x2;
			_vertices[verticesCount + 11] = y2;
			
			//Vertices count increment
			verticesCount+=12;
			
			//Start from where we left of
			x1 = x3; x2 = x4; y1 = y3; y2 = y4;
		}
	}
	
	//Last point on backbone
	Coord *last = [coords lastObject];
	
	//Texture coordinates
	_coordinates[verticesCount + 0] = 0;
	_coordinates[verticesCount + 1] = 0;
	_coordinates[verticesCount + 2] = 0;
	_coordinates[verticesCount + 3] = 1;
	_coordinates[verticesCount + 4] = 1;
	_coordinates[verticesCount + 5] = 0.5;
	
	//Last point vertices
	_vertices[verticesCount + 0] = x1;
	_vertices[verticesCount + 1] = y1;
	_vertices[verticesCount + 2] = x2;
	_vertices[verticesCount + 3] = y2;
	_vertices[verticesCount + 4] = last.posX;
	_vertices[verticesCount + 5] = last.posY;
	
	//Vertices count increment
	verticesCount+=6;
}

#pragma mark OS Events

-(void) dealloc {
	//Coordinates release
	[coords removeAllObjects];
	[coords release];
	coords = nil;
	
	//Super release
	[super dealloc];
}

@end
