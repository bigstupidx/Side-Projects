//
//  GLTexture.h
//  iEngine
//
//  Created by Safiul Azam on 6/28/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "LogUtility.h"

typedef enum {
	
	kTexture2DPixelFormat_Automatic = 0,
	kTexture2DPixelFormat_RGBA8888,
	kTexture2DPixelFormat_RGB565,
	kTexture2DPixelFormat_A8	
	
} Texture2DPixelFormat;

@interface GLTexture : NSObject {

	@private
	GLuint _identity;
	
	CGSize _size;
	CGFloat _alpha;
	CGPoint _scale;
	GLfloat _rotate;
	CGPoint _flip;
	
	GLint _width, _height;		
	Texture2DPixelFormat _pixelFormat;
	
	NSString *_filename;
}

- (id)initWithFilename:(NSString *) filename;

- (void) renew;

-(CGSize) getSize;

-(CGFloat) getAlpha;
-(void) setAlpha:(CGFloat) alpha;

- (CGPoint) getFlip;
- (void) setFlip:(CGPoint) flip;

- (CGPoint) getScale;
-(void) setScale:(CGPoint) scale;

- (CGFloat) getRotate;
- (void) setRotate:(CGFloat) rotate;

-(void) draw:(CGPoint) position; 
-(void) draw:(CGPoint) position :(CGRect) area;

@end
