//
//  TileCanvas.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TileCanvas.h"


@implementation TileCanvas

- (id) initWithSize:(CGSize) size :(TileScene *) tileScene;
{
	[super init];
	
	_size = size;
	_tileScene = tileScene;
	_center = CGPointMake(0, 0);
	_offset = 0;
	_zoom = 1;
	_scroll = CGPointMake(0, 0);
	
	return self;
}

- (CGSize) getSize
{
	return _size;
}

- (void) setSize:(CGSize) size
{
	_size = size;
}

- (TileScene *) getTileScene
{
	return _tileScene;
}

- (CGPoint) getCenter
{
	return _center;
}

- (void) setCenter:(CGPoint) center
{
	_center = center;
}

- (CGFloat) getOffset
{
	return _offset;
}

- (void) setOffset:(CGFloat) offset
{
	_offset = offset;
}

- (CGFloat) getZoom
{
	return _zoom;
}

- (void) setZoom:(CGFloat) zoom
{
	[self setZoom:zoom :CGPointMake(0, 0)];
}

- (void) setZoom:(CGFloat) zoom :(CGPoint) position
{
	if(zoom < 0)
		return;
	
	_zoom = zoom;
	
	[[self getTileScene] setScale:CGPointMake(_zoom, _zoom)];
		
	position.x = (position.x * _zoom);
	position.y = (position.y * _zoom);
	
	[self setScroll:position];	
}

- (void) zoomToFit
{	
	[self setZoom:1.0];
	
	CGFloat xZoom = [self getSize].width / [[self getTileScene] getSize].width;
	CGFloat yZoom = [self getSize].height / [[self getTileScene] getSize].height;
	CGFloat zoom = xZoom <= yZoom ? xZoom : yZoom;
	
	[self setZoom:zoom];
}

- (CGPoint) getScroll
{
	return _scroll;
}

- (void) setScroll:(CGPoint) scroll
{
	_scroll = scroll;
	
	if([[self getTileScene] getSize].width * [[self getTileScene] getScale].x + [self getOffset] * 2 > [self getSize].width)
	{
		CGFloat range = (([[self getTileScene] getSize].width * [[self getTileScene] getScale].x + [self getOffset] * 2) - [self getSize].width) / 2;
		_scroll.x = (_scroll.x < -range) ? -range : (_scroll.x > range ? range : _scroll.x);
	}
	else 
		_scroll.x = 0;

		
	if([[self getTileScene] getSize].height * [[self getTileScene] getScale].y + [self getOffset] * 2 > [self getSize].height)
	{
		CGFloat range = (([[self getTileScene] getSize].height * [[self getTileScene] getScale].y + [self getOffset] * 2) - [self getSize].height) / 2;
		_scroll.y = (_scroll.y < -range) ? -range : (_scroll.y > range ? range : _scroll.y);
	}
	else 
		_scroll.y = 0;

	[[self getTileScene] setCenter:CGPointMake(-_scroll.x, -_scroll.y)];
}

- (void) scroll:(CGPoint) distance
{
	CGFloat x = [self getScroll].x + distance.x;
	CGFloat y = [self getScroll].y + distance.y;
	
	[self setScroll:CGPointMake(x, y)];
}

-(void) draw
{
	
	// Enable scissor.
	glEnable(GL_SCISSOR_TEST);
	GLint scissor[4];
	glGetIntegerv(GL_SCISSOR_BOX, scissor);
	 
	GLint viewport[4];
	glGetIntegerv(GL_VIEWPORT, viewport);
	
	GLfloat xScissor = (viewport[0] + viewport[2] / 2) + ([self getCenter].x - [self getSize].width / 2);
	GLfloat yScissor = (viewport[1] + viewport[3] / 2) - ([self getCenter].y + [self getSize].height / 2);
	GLfloat widthScissor = [self getSize].width;
	GLfloat heightScissor = [self getSize].height;
	glScissor(xScissor, yScissor, widthScissor, heightScissor);
	 // ...
		
	glPushMatrix();
	glTranslatef([self getCenter].x, [self getCenter].y, 0.0);	
	 
	[self setScroll:[self getScroll]];	
	[[self getTileScene] draw];
	 
	glPopMatrix();	
	 
	// Disable scissor.
	glScissor(scissor[0], scissor[1], scissor[2], scissor[3]);
	glDisable(GL_SCISSOR_TEST);
	// ...
}

- (void) dealloc 
{	
	[super dealloc];
}

@end
