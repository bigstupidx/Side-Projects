//
//  LayerManager.mm
//  iEngine
//
//  Created by Safiul Azam on 7/12/09.
//  Copyright 2009 None. All rights reserved.
//

#import "LayerManager.h"
#import "LogUtility.h"



@implementation LayerManager

- (id)initWith:(CGRect) window {
	
	[self setWindow:window];
	
	[self setPosition:CGPointMake(0, 0)];
	
	_layers = [[NSMutableArray alloc] init];
    
    _follow = nil;
    _followArea = CGRectMake(-NSIntegerMax, -NSIntegerMax, NSIntegerMax, NSIntegerMax);
	
	return self;
}

-(CGPoint) getPosition {

	return _position;
}

-(void) setPosition:(CGPoint) position {

	_position = position;
}

-(CGRect) getWindow {

	return _window;
}

-(void) setWindow:(CGRect) window {
	
	_window = window;
}

-(void) moveWindow:(CGPoint) distance {

	CGRect window = [self getWindow];
	window.origin.x += distance.x;
	window.origin.y += distance.y;
	
	[self setWindow:window];
}

-(BOOL) isInWindow:(Layer *) layer {
	
	CGRect window = [self getWindow];
    
    CGPoint center = window.origin;
    CGSize size = window.size;
    
    CGPoint layerCenter = [layer getCenter];
    CGSize layerSize = [layer getSize];
    
    if(layerCenter.x + layerSize.width / 2 <= center.x - size.width / 2)
        return NO;
    else if(layerCenter.x - layerSize.width / 2 > center.x + size.width / 2)
        return NO;
    else if(layerCenter.y + layerSize.height / 2 <= center.y - size.height / 2)
        return NO;
    else if(layerCenter.y - layerSize.height / 2 > center.y + size.height / 2)
        return NO;
    
    return YES;
}

-(NSMutableArray *) getLayers {
	
	return _layers;
}

-(NSInteger) getCountLayers {
	
	return [[self getLayers] count];
}

-(Layer *) getLayer:(NSInteger) index {
	
	return [[self getLayers] objectAtIndex:index];
}

-(void) addLayer:(Layer *) layer {
		
	[[self getLayers] addObject:layer];
}

-(void) replaceLayer:(NSInteger) index :(Layer *) layer {
	
	Layer *layerTemp = [[self getLayers] objectAtIndex:index];
	
	[[self getLayers] replaceObjectAtIndex:index withObject:layer];
	
	[layerTemp release];
}

-(void) removeLayer:(Layer *) layer {
	
	[[self getLayers] removeObject:layer];
}

-(void) removeAllLayers {
	
	[[self getLayers] removeAllObjects];
}

-(Layer *) getFollow
{
    return _follow;
}

-(void) setFollow:(Layer *) layer
{
    _follow = layer;
}

-(CGRect) getFollowArea
{
    return _followArea;
}

-(void) setFollowArea:(CGRect) area
{
    _followArea = area;
}

- (void) onFollow;
{
    if([self getFollow] == nil)
        return;
    
    CGPoint center = [[self getFollow] getCenter];
    NSInteger x = center.x;
    NSInteger y = center.y;
    NSInteger width = [self getWindow].size.width;
    NSInteger height = [self getWindow].size.height;
    
    if(x - [self getWindow].size.width / 2 <= [self getFollowArea].origin.x)
        x = [self getFollowArea].origin.x + [self getWindow].size.width / 2;
    else if(x + [self getWindow].size.width / 2 > [self getFollowArea].origin.x + [self getFollowArea].size.width)
        x = ([self getFollowArea].origin.x + [self getFollowArea].size.width) - [self getWindow].size.width / 2;
    
    if(y - [self getWindow].size.height / 2 <= [self getFollowArea].origin.y)
        y = [self getFollowArea].origin.y + [self getWindow].size.height / 2;
    else if(y + [self getWindow].size.height / 2 > [self getFollowArea].origin.y + [self getFollowArea].size.height)
        y = ([self getFollowArea].origin.y + [self getFollowArea].size.height) - [self getWindow].size.height / 2;
    
    [self setWindow:CGRectMake(x, y, width, height)];
}


-(void) draw {
    
    [self onFollow];
		
	// Enable scissor.
	glEnable(GL_SCISSOR_TEST);
	GLint scissor[4];
	glGetIntegerv(GL_SCISSOR_BOX, scissor);
		
	GLint viewport[4];
	glGetIntegerv(GL_VIEWPORT, viewport);
	GLfloat xScissor = [self getPosition].x;
	GLfloat yScissor = viewport[3] - ([self getPosition].y + [self getWindow].size.height);
	GLfloat widthScissor = [self getWindow].size.width;
	GLfloat heightScissor = [self getWindow].size.height;
	glScissor(xScissor, yScissor, widthScissor, heightScissor);
	// ...
	
	glPushMatrix();
	glTranslatef([self getPosition].x, [self getPosition].y, 0.0);	
	glTranslatef(-[self getWindow].origin.x, -[self getWindow].origin.y, 0.0);
	
    for(NSInteger i = 0; i < [self getCountLayers]; i++) {
		
		Layer *layer = (Layer *) [self getLayer:i];
        if([self isInWindow:layer])
            [layer draw];
	}
		
	glPopMatrix();	
	
	// Disable scissor.
	glScissor(scissor[0], scissor[1], scissor[2], scissor[3]);
	glDisable(GL_SCISSOR_TEST);
	// ...
}

-(void) dealloc {
	
    [_layers removeAllObjects];
	[_layers release];
	
	[super dealloc];	
}

@end
