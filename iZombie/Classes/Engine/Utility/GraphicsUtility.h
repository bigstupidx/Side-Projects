//
//  GraphicsUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "Color.h"

@class GraphicsUtility;

@interface GraphicsUtility : NSObject 
{
}

+ (GraphicsUtility *) getInstance; 

- (void) drawRectangle:(CGRect) rectangle :(Color) color;

- (void) drawCircle:(CGPoint) center :(CGFloat) radius :(CGFloat) segments :(Color) color;

- (void) drawLine:(NSArray *) points :(CGFloat) thick :(Color) color;

- (void) drawLine:(CGPoint) point1 point2:(CGPoint) point2 thick:(CGFloat) thick color:(Color) color;

- (Color) getColorFromImage:(UIImage *) image position:(CGPoint) position;

- (CGContextRef) getARGBBitmapContextFromImage:(CGImageRef) image;

@end
