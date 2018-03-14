//
//  GLWindow.m
//  iEngine
//
//  Created by Safiul Azam on 6/28/09.
//  Copyright 2009 None. All rights reserved.
//

#import "GLWindow.h"

@implementation GLWindow

+ (Class)layerClass {
	
	return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect) frame 
{
	if ((self = [super initWithFrame:frame])) 
	{
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.layer;
        
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
		if (!_context || ![EAGLContext setCurrentContext:_context]) {
            
			[self release];
			return nil;
		}
		        
		[self setRequiredFPS:60];
	}
			
	[self onCreateSurface];
    
	return self;	
}

- (void) layoutSubviews 
{
	[EAGLContext setCurrentContext:_context];
	
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawFrameBuffer];
	
	[self onChangeSurface];
}

- (BOOL) createFramebuffer 
{
	glGenFramebuffersOES(1, &_viewFramebuffer);
	glGenRenderbuffersOES(1, &_viewRenderbuffer);
    
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _viewRenderbuffer);
    	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
    
	if (USE_DEPTH_BUFFER) {
		glGenRenderbuffersOES(1, &_depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderbuffer);
	}
    
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
    
	return YES;
}

- (void) drawFrameBuffer 
{
	[EAGLContext setCurrentContext:_context];
    
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
	glViewport(0, 0, _backingWidth, _backingHeight);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	//glOrthof(0.0, _backingWidth, _backingHeight, 0, -1.0f, 1.0f); = Top-left (0, 0).
	glOrthof(-_backingWidth / 2, _backingWidth / 2, _backingHeight / 2, -_backingHeight / 2, -1.0f, 1.0f); // = Center (0, 0).
	glMatrixMode(GL_MODELVIEW);
	
	[self onDrawFrame];
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void) destroyFramebuffer 
{
	glDeleteFramebuffersOES(1, &_viewFramebuffer);
	_viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
	_viewRenderbuffer = 0;
    
	if(_depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
		_depthRenderbuffer = 0;
	}
}

- (void) start
{
	_fpsTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / _requiredFPS) target:self selector:@selector(drawFrameBuffer) userInfo:nil repeats:YES];
}

- (void) stop 
{
	[_fpsTimer invalidate];
	_fpsTimer = nil;
}

-(void) clear:(Color) color {
	
	glClearColor(color.red, color.green, color.blue, color.alpha);
	glClear(GL_COLOR_BUFFER_BIT);
}

-(void) clear {
	
	[self clear:ColorMake(0.0, 0.0, 0.0, 1.0)];
}

- (void) onCreateSurface
{
	
}

- (void) onChangeSurface
{
	
}

- (void) onDrawFrame {
	
}

- (NSInteger) getRequiredFPS 
{
	return _requiredFPS;
}

- (void) setRequiredFPS:(NSInteger) fps
{	
	_requiredFPS = fps < 1 ? 1 : fps;
}

- (void) dealloc 
{
	[self destroyFramebuffer];
	
	[_context release];
		
	[super dealloc];
}

@end
