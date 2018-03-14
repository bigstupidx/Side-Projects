//
//  Scroller.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Scroller.h"
#import "Texture.h"

@implementation Scroller

-(id)initWithSize:(CGSize) size :(Texture *) texture
{
    [super initWithSize:size];
    
    _texture = texture;
    [_texture retain];
    
    _scroll = CGPointMake(0, 0);
    
    return self;
}

-(Texture *) getTexture
{
    return _texture;
}

-(void) scroll:(CGPoint) distance
{
    _scroll.x -= distance.x;
    _scroll.y -= distance.y;
    
    CGSize size = [self getSize];
    
    if(distance.x > 0)
    {
        if(_scroll.x < -(size.width / 2 + size.width))
            _scroll.x = -(size.width / 2) - (-(size.width / 2 + size.width) - _scroll.x);
    }
    else if(distance.x < 0)
    {
        if(_scroll.x > (size.width / 2 + size.width))
            _scroll.x = (size.width / 2) - ((size.width / 2 + size.width) - _scroll.x);
    }
    
    [[LogUtility getInstance] printMessage:@"Scroll..."];
    [[LogUtility getInstance] printPoint:_scroll];
}

-(void) draw
{
    if(![self isVisible])
		return;
	
	[super draw];
    
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
    
    CGFloat alpha = [[self getTexture] getAlpha];
    [[self getTexture] setAlpha:[self getAlpha]];
    
    // Draw here.
    CGSize size = [self getSize];
    
    // On right.
    CGFloat distance = size.width / 2 - _scroll.x;
    NSInteger count = ceil(distance / [_texture getSize].width);
    
    for(NSInteger i = 0; i < count; i++)
    {
        CGFloat x = _scroll.x + (i * [_texture getSize].width);
        CGFloat y = -(size.height / 2);
        
        [_texture draw:CGPointMake(x, y) ];
    }
    
    // On left.
    distance = _scroll.x - (-(size.width / 2));
    count = ceil(distance / [_texture getSize].width);
    
    for(NSInteger i = 0; i < count; i++)
    {
        CGFloat x = _scroll.x - ((i + 1) * [_texture getSize].width);
        CGFloat y = -(size.height / 2);
        
        [_texture draw:CGPointMake(x, y)];
    }
    
    [[self getTexture] setAlpha:alpha];
    
	glPopMatrix();	
}

- (void) dealloc
{
    [_texture release];
    
    [super dealloc];
}

@end
