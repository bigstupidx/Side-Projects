//
//  TileScene.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TileScene.h"


@implementation TileScene

- (id) initWithTileMap:(TileMap *) tileMap
{
	[super initWithSize:[tileMap getSize]];
	
	_tileMap = tileMap;
	[_tileMap retain];
	
	_bottomTileLayer = [[MyTileLayer alloc] initWithTileMap:_tileMap];
    [_bottomTileLayer setDepthSort:NO];
    
	_topTileLayer = [[MyTileLayer alloc] initWithTileMap:_tileMap];
	[_topTileLayer setDepthSort:YES];
    
	_wireframe = YES;
	_wireframeColor = ColorMake(1.0, 1.0, 1.0, 1.0);
	_wireframeThickness = 1.0;
	
	return self;
}

- (TileMap *) getTileMap
{
	return _tileMap;
}

- (MyTileLayer *) getTopTileLayer
{
	return _topTileLayer;
}

- (MyTileLayer *) getBottomTileLayer
{
	return _bottomTileLayer;
}

- (BOOL) isWireframe
{
	return _wireframe;
}

- (void) setWireframe:(BOOL) wireframe
{
	_wireframe = wireframe;
}

- (Color) getWireframeColor
{
	return _wireframeColor;
}

- (void) setWireframeColor:(Color) color
{
	_wireframeColor = color;
}

- (CGFloat) getWireframeThickness
{
	return _wireframeThickness;
}

- (void) setWireframeThickness:(CGFloat) thickness
{
	_wireframeThickness = thickness;
}

- (void) draw
{
	if(![self isVisible])
		return;
	
	glPushMatrix();
	glTranslatef([self getCenter].x, [self getCenter].y, 0.0);	
	
	// Flip.
	if([self getFlip] != FlipNone) {
		
		if([self getFlip] == FlipHorizontal)
			glRotatef(180.0, 0.0, 1.0, 0.0);
		else if([self getFlip] == FlipVertical)
			glRotatef(180.0, 1.0, 0.0, 0.0);
		else {
			
			glRotatef(180.0, 0.0, 1.0, 0.0);
			glRotatef(180.0, 1.0, 0.0, 0.0);
		}
	}
	
	glScalef([self getScale].x, [self getScale].y, 0);
	glRotatef([self getRotate], 0.0, 0.0, 1.0);
	
	// Draw bottom layer.
	[[self getBottomTileLayer] setCenter:CGPointMake(0, 0)];
	[[self getBottomTileLayer] draw];
		
	// Draw wireframe.
	if([self isWireframe])
	{
		Tile *tile;
		CGFloat x, y;
		CGPoint point0, point1, point2, point3, point4;
		NSArray *points;
		
		for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
			for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			{
				tile = [[self getTileMap] getTileAtIndex:IndexMake(j, i)];
			
				x = [tile getCenter].x - [tile getSize].width / 2;
				y = [tile getCenter].y - [tile getSize].height / 2;
						
				if([[self getTileMap] getOrientation] == OrientationIsometric)
				{
					point0 = CGPointMake(x + [tile getSize].width / 2, y);
					point1 = CGPointMake(x + [tile getSize].width, y + [tile getSize].height / 2);
					point2 = CGPointMake(x + [tile getSize].width / 2, y + [tile getSize].height);
					point3 = CGPointMake(x, y + [tile getSize].height / 2);
					point4 = point0;
				}
				else 
				{
					point0 = CGPointMake(x, y);
					point1 = CGPointMake(x + [tile getSize].width, y);
					point2 = CGPointMake(x + [tile getSize].width, y + [tile getSize].height);
					point3 = CGPointMake(x, y + [tile getSize].height);
					point4 = point0;
				}

			
				points = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point0], [NSValue valueWithCGPoint:point1],
						  [NSValue valueWithCGPoint:point2], [NSValue valueWithCGPoint:point3], [NSValue valueWithCGPoint:point4], nil];
			
				[[GraphicsUtility getInstance] drawLine:points :[self getWireframeThickness] :[self getWireframeColor]];
		}
	}
	
	// Draw top layer.
	[[self getTopTileLayer] setCenter:CGPointMake(0, 0)];
	[[self getTopTileLayer] draw];
	
	glPopMatrix();
}

- (void) dealloc 
{
	[_tileMap release];	
	
	[super dealloc];
}

@end
