//
//  Layer.mm
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import "Layer.h"

@implementation Layer

- (id) initWithSize:(CGSize) size 
{
	[super init];
	
	_size = size;
	
	[self setParent:nil];
			
	[self setCenter:CGPointMake(0.0, 0.0)];
	
	[self setScale:CGPointMake(1.0, 1.0)];
	
	[self setRotate:0.0];
    
    [self setAlpha:1.0];
	
	[self setFlip:FlipNone];
		
	[self setVisible:YES];
	
	return self;
}

-(CGSize) getSize {
	
	return _size;
}

-(LayerContainer *) getParent {
	
	return _parent;
}

-(void) setParent:(LayerContainer *) parent {
	
    if(_parent != nil)
    {
        [_parent release];
        _parent = nil;
    }
    
	_parent = parent;
    
    if(parent != nil)
        [_parent retain];
}

-(CGPoint) getCenter {

	return _center;
}

-(void) setCenter:(CGPoint) center {

	_center = center;
}

-(CGPoint) getScale {

	return _scale;
}

-(void) setScale:(CGPoint) scale {

	_scale = scale;
}

-(CGFloat) getRotate {

	return _rotate;
}

-(void) setRotate:(CGFloat) rotate {

	_rotate = rotate;
}

-(CGFloat) getAlpha
{
    return _alpha;
}

-(void) setAlpha:(CGFloat) alpha
{
    _alpha = alpha;
}

-(Flip) getFlip {

	return _flip;
}

-(void) setFlip:(Flip) flip {

	_flip = flip;
}

-(BOOL) isVisible {

	return _visible;
}

-(void) setVisible:(BOOL) visible {

	_visible = visible;
}

-(void) move:(CGPoint) distance {

	[self setCenter:CGPointMake([self getCenter].x + distance.x, [self getCenter].y + distance.y)];
}

-(CGPoint) getPosition:(CGPoint) local {
	
	CGFloat x = - ([self getSize].width * [self getScale].x) / 2 + local.x;
	CGFloat y = - ([self getSize].height * [self getScale].y) / 2 + local.y;
	
	CGFloat radian = [[MathUtility getInstance] getDegreeToRadian:[self getRotate]];
	CGFloat x2 = [self getCenter].x + (x * cos(radian) - y * sin(radian));
	CGFloat y2 = [self getCenter].y + (x * sin(radian) + y * cos(radian));
	
	return CGPointMake(x2, y2);
}

-(CGRect) getFrame {
	
	CGFloat width = [self getSize].width * [self getScale].x;
	CGFloat height = [self getSize].height * [self getScale].y;
	CGPoint position = [self getPosition:CGPointMake(0, 0)];
		
	return CGRectMake(position.x, position.y, width, height);
}

-(CGRect) getBounds {
		
	NSArray *vertices = [self getVertices];
	
	CGFloat minX = CGFLOAT_MAX;
	CGFloat maxX = -CGFLOAT_MAX;
	
	CGFloat minY = CGFLOAT_MAX;
	CGFloat maxY = -CGFLOAT_MAX;
	
	for(NSInteger i = 0; i < [vertices count]; i++) {
		
		CGPoint point = [(NSValue *) [vertices objectAtIndex:i] CGPointValue];
				
		if(point.x < minX)
			minX = point.x;
		
		if(point.x > maxX)
			maxX = point.x;
		
		if(point.y < minY)
			minY = point.y;
		
		if(point.y > maxY)
			maxY = point.y;		
	}
	
	return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

-(NSArray *) getVertices {

	CGRect frame = [self getFrame];
	
	CGPoint topLeft = [self getPosition:CGPointMake(0, 0)];
	CGPoint topRight = [self getPosition:CGPointMake(frame.size.width - 1, 0)];
	CGPoint bottomLeft = [self getPosition:CGPointMake(0, frame.size.height - 1)];
	CGPoint bottomRight = [self getPosition:CGPointMake(frame.size.width - 1, frame.size.height - 1)];
	
	return [NSArray arrayWithObjects:
			[NSValue valueWithCGPoint:topLeft],
			[NSValue valueWithCGPoint:topRight],
			[NSValue valueWithCGPoint:bottomLeft],
			[NSValue valueWithCGPoint:bottomRight]
			, nil];
}

-(void) draw 
{
}

-(void) update
{
}

-(void) dealloc {
    
    if(_parent != nil)
        [_parent release];

	[super dealloc];	
}

@end
