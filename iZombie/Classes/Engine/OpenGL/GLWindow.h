//
//  GLWindow.h
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
#import "Color.h"

#define USE_DEPTH_BUFFER 0

@interface GLWindow : UIView {
	
	@private
	GLint _backingWidth;
	GLint _backingHeight;
    
	EAGLContext *_context;
    
	GLuint _viewRenderbuffer;
	GLuint _viewFramebuffer;
	GLuint _depthRenderbuffer;
    
	NSTimer *_fpsTimer;
	
	NSInteger _requiredFPS;
}

- (void) clear:(Color) color;
- (void) clear;

- (void) onCreateSurface;
- (void) onChangeSurface;
- (void) onDrawFrame;

- (NSInteger) getRequiredFPS;
- (void) setRequiredFPS:(NSInteger) fps;

- (void) start;
- (void) stop;

@end

