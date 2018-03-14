//
//  Tile.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"


@implementation Tile

- (id) initWithSize:(CGSize) size :(CGPoint) center :(Index) index
{
	[super init];
	
	_size = size;	
	_center = center;	
	_index = index;	
	_accessible = YES;
	
	return self;
}

- (CGSize) getSize
{
	return _size;
}

- (CGPoint) getCenter
{
	return _center;
}

- (Index) getIndex
{
	return _index;
}

- (BOOL) isAccessible
{
	return _accessible;
}

- (void) setAccessible:(BOOL) accessible
{
	_accessible = accessible;
}

- (void) dealloc 
{
	[super dealloc];
}

@end
