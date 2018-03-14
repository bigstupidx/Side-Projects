//
//  TileCanvas.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "TileScene.h"

@interface TileCanvas : NSObject {

	@private
	CGPoint _center;
	CGSize _size;
	TileScene *_tileScene;
	CGFloat _offset;
	CGFloat _zoom;
	CGPoint _scroll;
}

- (id) initWithSize:(CGSize) size :(TileScene *) tileScene;

- (CGSize) getSize;
- (void) setSize:(CGSize) size;

- (TileScene *) getTileScene;

- (CGPoint) getCenter;
- (void) setCenter:(CGPoint) center;

- (CGFloat) getOffset;
- (void) setOffset:(CGFloat) offset;

- (CGFloat) getZoom;
- (void) setZoom:(CGFloat) zoom;
- (void) setZoom:(CGFloat) zoom :(CGPoint) position;
- (void) zoomToFit;

- (CGPoint) getScroll;
- (void) setScroll:(CGPoint) scroll;
- (void) scroll:(CGPoint) distance;

-(void) draw;

@end
