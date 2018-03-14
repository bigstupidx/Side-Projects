//
//  LogUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LogUtility.h"

static LogUtility *_logUtility = nil;

@implementation LogUtility

- (id) init 
{
	[super init];
	
	_permission = YES;
	
	return self;
}

+ (LogUtility *) getInstance 
{
	if(_logUtility == nil)
		_logUtility = [[LogUtility alloc] init];
	
	return _logUtility;
}

- (BOOL) isPermission
{
	return _permission;
}

- (void) setPermission:(BOOL) permission
{
	_permission = permission;
}

- (void) print:(NSString *) message
{
	if([[LogUtility getInstance] isPermission])
		NSLog(@"%@", message);
}

- (void) printMessage:(NSString *) message
{
	if([[LogUtility getInstance] isPermission])
		NSLog(@"Message: %@", message);
}

- (void) printFloat:(CGFloat) value
{
	NSString *message = [NSString stringWithFormat:@"Float: %f", value];
	
	[[LogUtility getInstance] print:message];
}

- (void) printPoint:(CGPoint) point
{
	NSString *message = [NSString stringWithFormat:@"Point (X, Y): %f %f", point.x, point.y];
	
	[[LogUtility getInstance] print:message];
}

- (void) printIndex:(Index) index
{
	NSString *message = [NSString stringWithFormat:@"Index (Column, Row): %i %i", index.column, index.row];
	
	[[LogUtility getInstance] print:message];
}

- (void) printSize:(CGSize) size
{
	NSString *message = [NSString stringWithFormat:@"Size (Width, Height): %f %f", size.width, size.height];
	
	[[LogUtility getInstance] print:message];
}

- (void) printRectangle:(CGRect) rectangle
{
	NSString *message = [NSString stringWithFormat:@"Rectangle (X, Y, Width, Height): %f %f %f %f", rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height];
	
	[[LogUtility getInstance] print:message];
}

- (void) dealloc 
{
	[super dealloc];
}

@end
