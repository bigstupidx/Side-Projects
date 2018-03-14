//
//  Window.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "GLWindow.h"
#import "Touch.h"

@interface Window : GLWindow {

	@private
}

- (void) onCreateRenderer;
- (void) onChangeRenderer;
- (void) onDrawRenderer;

- (void) onTouchesBegin:(NSArray *) positions :(NSInteger) count;
- (void) onTouchesMove:(NSArray *) positions :(NSInteger) count;
- (void) onTouchesEnd:(NSArray *) positions :(NSInteger) count;

@end
