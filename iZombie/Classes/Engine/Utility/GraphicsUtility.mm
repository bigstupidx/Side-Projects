//
//  GraphicsUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GraphicsUtility.h"

static GraphicsUtility *_graphicsUtility = nil;

@implementation GraphicsUtility

- (id) init 
{
	[super init];
	
	return self;
}

+ (GraphicsUtility *) getInstance 
{
	if(_graphicsUtility == nil)
		_graphicsUtility = [[GraphicsUtility alloc] init];
	
	return _graphicsUtility;
}

- (void) drawRectangle:(CGRect) rectangle :(Color) color
{
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	GLint countVertices = 4;
	
	GLfloat* vertices;
	vertices = new GLfloat[countVertices * 2];
	
	vertices[0] = rectangle.origin.x;
	vertices[1] = rectangle.origin.y;
	
	vertices[2] = rectangle.origin.x+ rectangle.size.width;
	vertices[3] = rectangle.origin.y;
	
	vertices[4] = rectangle.origin.x;
	vertices[5] = rectangle.origin.y + rectangle.size.height;
	
	vertices[6] = rectangle.origin.x + rectangle.size.width;
	vertices[7] = rectangle.origin.y + rectangle.size.height;
	
	GLfloat* colors;
	colors = new GLfloat[countVertices * 4];
	
	for(int i = 0; i < countVertices * 4; i++) {
		colors[i] = color.red;
		colors[++i] = color.green;
		colors[++i] = color.blue;
		colors[++i] = color.alpha;
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);	
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, countVertices);
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);	
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_BLEND);
	
	delete[] vertices;
	vertices = NULL;
	delete[] colors;
	colors = NULL;
}

- (void) drawCircle:(CGPoint) center :(CGFloat) radius :(CGFloat) segments :(Color) color
{
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	GLint countVertices =  segments + 2;
	
	GLfloat* vertices;
	vertices = new GLfloat[countVertices * 2];
	
	vertices[0] = center.x;
	vertices[1] = center.y;
	
	for(int i = 2, angle = 0; i < countVertices * 2; i++, angle += 360 / (countVertices - 2))
	{
		vertices[i] = center.x + cos(angle * M_PI / 180) * radius;
		vertices[++i] = center.y + sin(angle * M_PI / 180) * radius;
	}	
	
	GLfloat* colors;
	colors = new GLfloat[countVertices * 4];
	
	for(int i = 0; i < countVertices * 4; i++) {
		colors[i] = color.red;
		colors[++i] = color.green;
		colors[++i] = color.blue;
		colors[++i] = color.alpha;
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);	
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, countVertices);
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);	
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_BLEND);
	
	delete[] vertices;
	vertices = NULL;
	delete[] colors;
	colors = NULL;
}

- (void) drawLine:(NSArray *) points :(CGFloat) thick :(Color) color 
{
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	GLint countVertices = [points count];
	
	GLfloat* vertices;
	vertices = new GLfloat[countVertices * 2];
	
	for(int i = 0; i < [points count]; i++) {
		
		NSValue *value = [points objectAtIndex:i];
		CGPoint point = [value CGPointValue];
		
		int index = i * 2;		
		vertices[index] = point.x;
		vertices[++index] = point.y;
	}
	
	GLfloat* colors;
	colors = new GLfloat[countVertices * 4];
	
	for(int i = 0; i < countVertices * 4; i++) {
		colors[i] = color.red;
		colors[++i] = color.green;
		colors[++i] = color.blue;
		colors[++i] = color.alpha;
	}
	
	glLineWidth(thick);
	glVertexPointer(2, GL_FLOAT, 0, vertices);	
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glDrawArrays(GL_LINE_STRIP, 0, countVertices);
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);	
	glLineWidth(1.0);
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_BLEND);
	
	delete[] vertices;
	vertices = NULL;
	delete[] colors;
	colors = NULL;
}

- (void) drawLine:(CGPoint) point1 point2:(CGPoint) point2 thick:(CGFloat) thick color:(Color) color 
{
	NSValue *value1 = [NSValue valueWithCGPoint:point1];
	NSValue *value2 = [NSValue valueWithCGPoint:point2];
	
	NSArray *points = [NSArray arrayWithObjects:value1, value2, nil];
	
	[[GraphicsUtility getInstance] drawLine:points :thick :color];
}

- (Color) getColorFromImage:(UIImage *) image position:(CGPoint) position {
	
	Color color;
	
	CGImageRef inImage = image.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [[GraphicsUtility getInstance] getARGBBitmapContextFromImage:inImage];
	
	if (cgctx == NULL) { 
		
		return ColorMake(0.0, 0.0, 0.0, 0.0);		
		/* error */ 
	}
	
	size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a positioner to the image data associated with the bitmap
	// context.
	unsigned char* data = (unsigned char *) CGBitmapContextGetData (cgctx);
	if (data != NULL) {
		//offset locates the pixel in the data from x,y. 
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*((w*round(position.y))+round(position.x));
		int alpha =  data[offset]; 
		int red = data[offset+1]; 
		int green = data[offset+2]; 
		int blue = data[offset+3]; 
		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		color = ColorMake(red / 255.0f, green / 255.0f, blue / 255.0f, alpha / 255.0f);
	}
	
	// When finished, release the context
	CGContextRelease(cgctx); 
	// Free image data memory for the context
	if (data) { free(data); }
	
	return color;
}

- (CGContextRef) getARGBBitmapContextFromImage:(CGImageRef) image {
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(image);
	size_t pixelsHigh = CGImageGetHeight(image);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
	
	return context;
}

- (void) dealloc 
{
	[super dealloc];
}

@end
