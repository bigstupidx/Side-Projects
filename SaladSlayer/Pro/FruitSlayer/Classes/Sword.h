//
//  Sword.h
//

#import "GLView.h"
#import "Coord.h"
#import "Geometry.h"
#import "Audio.h"

@class GLView;
@class Coord;
@class Geometry;
@class Audio;

@interface Sword : NSObject {
	//Touch
	NSMutableArray *coords;
	int touchID;
	int segmentsAdded;
	bool active;
	float posX;
	float posY;
	float lastX;
	float lastY;
	float tempX;
	float tempY;
	float vectorUngle;
	float vectorSpeed;
	float radius;
	bool shouldEnd;
	
	//Sound
	bool soundPlayed;
	int soundFrames;
	
	//Vertices
	int verticesCount;
	GLfloat _vertices[5000];
	GLfloat _coordinates[5000];
}

#pragma mark Properties

@property (nonatomic, retain) NSMutableArray *coords;
@property (nonatomic) int touchID;
@property (nonatomic) int segmentsAdded;
@property (nonatomic) bool active;
@property (nonatomic) float posX;
@property (nonatomic) float posY;
@property (nonatomic) float tempX;
@property (nonatomic) float tempY;
@property (nonatomic) float vectorUngle;
@property (nonatomic) float vectorSpeed;
@property (nonatomic) float radius;
@property (nonatomic) bool shouldEnd;
@property (nonatomic) int verticesCount;
@property (readonly) GLfloat *vertices;
@property (readonly) GLfloat *coordinates;

#pragma mark Methods

-(id) initWithTouchID: (int) tid CoordX: (float) cx CoordY: (float) cy;

-(void) playRandomSound;

-(void) addCoordX:(float) cx CoordY:(float) cy Force: (bool) force;

-(void) endCoords;

-(void) newFrame;

@end
