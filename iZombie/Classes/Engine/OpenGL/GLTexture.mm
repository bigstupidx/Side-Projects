//
//  GLTexture.m
//  iEngine
//
//  Created by Safiul Azam on 6/28/09.
//  Copyright 2009 None. All rights reserved.
//

#import "GLTexture.h"


@implementation GLTexture

- (id) initWithFilename:(NSString *) filename 
{
	_filename = filename;
	
	[self renew];
	
	return self;
}

- (void) renew {

	[self setAlpha:1.0];
	[self setRotate:0.0];
	[self setFlip:CGPointMake(0.0, 0.0)];
	[self setScale:CGPointMake(1.0, 1.0)];
	
	NSString *extension = [_filename pathExtension];
	
	NSString *address = [_filename substringWithRange:NSMakeRange(0, [_filename length] - ([extension length] + 1))];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:address ofType:extension];
	
	NSData *contents = [NSData dataWithContentsOfFile:path];
	
	UIImage *image = [UIImage imageWithData:contents];
			
	CGImageRef imageRef = [image CGImage];
	
	if(imageRef == nil)
	{
		NSString *message = [NSString stringWithFormat:@"Error: %@ is nil.", _filename];
		[[LogUtility getInstance] print:message];
		return;
	}
	else 
	{
		NSString *message = [NSString stringWithFormat:@"Success: %@ is loaded.", _filename];
		[[LogUtility getInstance] print:message];
	}
	
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	BOOL hasAlpha = ((alphaInfo == kCGImageAlphaPremultipliedLast) || (alphaInfo == kCGImageAlphaPremultipliedFirst) || (alphaInfo == kCGImageAlphaLast) || (alphaInfo == kCGImageAlphaFirst) ? YES : NO);
	
	if(CGImageGetColorSpace(imageRef)) {
		
		if(hasAlpha)
			_pixelFormat = kTexture2DPixelFormat_RGBA8888;
		else
			_pixelFormat = kTexture2DPixelFormat_RGB565;
	} else  
		// No colorspace means a mask imageRef
		_pixelFormat = kTexture2DPixelFormat_A8;
		
	_size = CGSizeMake(CGImageGetWidth(imageRef), (GLint) CGImageGetHeight(imageRef));
	
	CGSize imageRefSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	BOOL sizeToFit = NO;
	
	_width = imageRefSize.width;
	
	GLint i;
	if((_width != 1) && (_width & (_width - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < _width)
			i *= 2;
		_width = i;
	}
	
	_height = imageRefSize.height;
		
	if((_height != 1) && (_height & (_height - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < _height)
			i *= 2;
		_height = i;
	}
	
	GLint kMaxTextureSize = 1024;
	
	while((_width > kMaxTextureSize) || (_height > kMaxTextureSize)) {
		_width /= 2;
		_height /= 2;
		transform = CGAffineTransformScale(transform, 0.5, 0.5);
		imageRefSize.width *= 0.5;
		imageRefSize.height *= 0.5;
	}
	
	CGContextRef context = nil;
	
	void *data = nil;;
	
	CGColorSpaceRef colorSpace;
	
	switch(_pixelFormat) {		
		case kTexture2DPixelFormat_RGBA8888:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			data = malloc(_height * _width * 4);
			context = CGBitmapContextCreate(data, _width, _height, 8, 4 * _width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
			CGColorSpaceRelease(colorSpace);
			break;
		case kTexture2DPixelFormat_RGB565:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			data = malloc(_height * _width * 4);
			context = CGBitmapContextCreate(data, _width, _height, 8, 4 * _width, colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
			CGColorSpaceRelease(colorSpace);
			break;
			
		case kTexture2DPixelFormat_A8:
			data = malloc(_height * _width);
			context = CGBitmapContextCreate(data, _width, _height, 8, _width, NULL, kCGImageAlphaOnly);
			break;				
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
	}
	
	CGContextClearRect(context, CGRectMake(0, 0, _width, _height));
	
	CGContextTranslateCTM(context, 0, _height - imageRefSize.height);
	
	if(!CGAffineTransformIsIdentity(transform))
		CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), imageRef);
	
	void *tempData;
	
	unsigned int *inPixel32;
	
	unsigned short *outPixel16;
	
	if(_pixelFormat == kTexture2DPixelFormat_RGB565) {
		
		tempData = malloc(_height * _width * 2);
		
		inPixel32 = (unsigned int*)data;
		
		outPixel16 = (unsigned short*)tempData;
		
		for(i = 0; i < _width * _height; ++i, ++inPixel32)
			*outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) | ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0);
		
		free(data);
		
		data = tempData;		
	}
	
	// Generate and bind as texture.
	GLint name;
	
	glGenTextures(1, &_identity);
	
	glGetIntegerv(GL_TEXTURE_BINDING_2D, &name);
	
	glBindTexture(GL_TEXTURE_2D, _identity);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	switch(_pixelFormat) {
			
		case kTexture2DPixelFormat_RGBA8888:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
			break;
		case kTexture2DPixelFormat_RGB565:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, _width, _height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, data);
			break;
		case kTexture2DPixelFormat_A8:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, _width, _height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@""];
			
	}
	
	glBindTexture(GL_TEXTURE_2D, name);
	
	CGContextRelease(context);
	
	free(data);
}

-(CGSize) getSize {
	
	return CGSizeMake(_size.width * _scale.x, _size.height * _scale.y);
}

- (CGFloat) getAlpha
{
	return _alpha;
}

- (void) setAlpha:(CGFloat) alpha
{
	
	alpha = (alpha < 0 ? 0 : (alpha > 1 ? 1 : alpha));

	_alpha = alpha;
}

- (CGPoint) getFlip
{
	return _flip;
}

- (void) setFlip:(CGPoint) flip
{	
	_flip = flip;
}

- (CGFloat) getRotate
{
	return _rotate;
}

- (void) setRotate:(CGFloat) rotate
{
	_rotate = (GLint) rotate % 360;
}

- (CGPoint) getScale
{
	return _scale;
}

- (void) setScale:(CGPoint) scale
{	
	scale.x = scale.x < 0 ? 0 : scale.x;
	scale.y = scale.y < 0 ? 0 : scale.y;
		
	_scale = CGPointMake((GLfloat) scale.x, (GLfloat) scale.y);
}

- (void) draw:(CGPoint) position 
{
	[self draw:position :CGRectMake(0, 0, [self getSize].width, [self getSize].height)];
}

- (void) draw:(CGPoint) position :(CGRect) area 
{
	// Rotate.
	glPushMatrix();
	glTranslatef(position.x + area.size.width / 2, position.y + area.size.height / 2, 0.0);
	
	// Flip.
	if(_flip.x != 0)
		glRotatef(180.0, 0.0, _flip.x, 0.0);
	if(_flip.y != 0)
		glRotatef(180.0, _flip.y, 0.0, 0.0);
	
	glRotatef((GLfloat) _rotate, 0.0, 0.0, 1.0);	
	glTranslatef(- position.x - area.size.width / 2, - position.y - area.size.height / 2, 0.0);
	
	area.origin.x /= _scale.x;
	area.size.width /= _scale.x;
	
	area.origin.y /= _scale.y;
	area.size.height /= _scale.y;
	
	// Scale.
	glPushMatrix();
	glTranslatef(position.x, position.y, 0);		
	glScalef(_scale.x, _scale.y, 0);
	glTranslatef(-position.x, -position.y, 0);
	
	// Draw.	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		
	GLfloat vertices[] = {
	
		vertices[0] = position.x,
		vertices[1] = position.y,
		vertices[2] = 0.0,
		vertices[3] = position.x + area.size.width,
		vertices[4] = position.y,
		vertices[5] = 0.0,
		vertices[6] = position.x,
		vertices[7] = position.y + area.size.height,
		vertices[8] = 0.0,
		vertices[9] = position.x + area.size.width,
		vertices[10] = position.y + area.size.height,
		vertices[11] = 0.0
	};
	
	GLfloat coordinates[] = {
	
		coordinates[0] = (float) area.origin.x / (float) _width,
		coordinates[1] = (float) area.origin.y / (float) _height,
		coordinates[2] = (float) (area.origin.x + area.size.width) / (float) _width,
		coordinates[3] = (float) area.origin.y / (float) _height,
		coordinates[4] = (float) area.origin.x / (float) _width,
		coordinates[5] = (float) (area.origin.y + area.size.height) / (float) _height,
		coordinates[6] = (float) (area.origin.x + area.size.width) / (float) _width,
		coordinates[7] = (float) (area.origin.y + area.size.height) / (float) _height,
	};
	
	GLfloat *colors = new GLfloat[4 * 4];
	
	for(int i = 0; i < 4 * 4; i++) {
		colors[i] = _alpha;
		colors[++i] = _alpha;
		colors[++i] = _alpha;
		colors[++i] = _alpha;
	}
	
	glBindTexture(GL_TEXTURE_2D, _identity);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);	
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_BLEND);
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	glPopMatrix();
	
	glPopMatrix();
}

- (void) dealloc 
{
	glDeleteTextures(1, &_identity);
	
	[super dealloc];
}

@end
