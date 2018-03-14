//
//  Layer.h
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Element.h"
#import "Flip.h"
#import "MathUtility.h"

@class LayerContainer;

@interface Layer : Element {
	
@private
	
	LayerContainer *_parent;
		
	CGSize _size;
	CGPoint _center;
	CGPoint _scale;
	CGFloat _rotate;
    CGFloat _alpha;
	Flip _flip;
	BOOL _visible;
}

- (id)initWithSize:(CGSize) size;
-(CGSize) getSize;

-(LayerContainer *) getParent;
-(void) setParent:(LayerContainer *) parent;

-(CGPoint) getCenter;
-(void) setCenter:(CGPoint) center;

-(CGPoint) getScale;
-(void) setScale:(CGPoint) scale;

-(CGFloat) getRotate;
-(void) setRotate:(CGFloat) rotate;

-(CGFloat) getAlpha;
-(void) setAlpha:(CGFloat) alpha;

-(Flip) getFlip;
-(void) setFlip:(Flip) flip;

-(BOOL) isVisible;
-(void) setVisible:(BOOL) visible;

-(void) move:(CGPoint) distance;

-(CGPoint) getPosition:(CGPoint) local;
-(CGRect) getFrame;
-(CGRect) getBounds;
-(NSArray *) getVertices;

-(void) draw;

@end
