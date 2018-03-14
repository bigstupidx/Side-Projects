//
//  AStarNode.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AStarNode.h"


@implementation AStarNode

- (id) initWithPosition:(CGPoint) position
{
	[self init];
	
	_position = position;
	
	_parent = nil;
	_neighbors = [[NSMutableArray alloc] init];
	_distance = 0;
	_accessible = YES;
	
	return self;
}

- (AStarNode *) getParent
{
	return _parent;
}

- (void) setParent:(AStarNode *) parent
{
	_parent = parent;
}

- (CGPoint) getPosition
{
	return _position;
}

- (void) setPosition:(CGPoint) position
{
	_position = position;
}

- (CGFloat) getDistance
{
	return _distance;
}

- (void) setDistance:(CGFloat) distance
{
	_distance = distance;
}

- (BOOL) isAccessible
{
	return _accessible;
}

- (void) setAccessible:(BOOL) accessible
{
	_accessible = accessible;
}

- (NSArray *) getNeighbors
{
	return (NSArray *) _neighbors;
}

- (NSInteger) getCountNeighbors
{
	return [_neighbors count];
}

- (AStarNode *) getNeighbor:(NSInteger) index
{
	return (AStarNode *) [_neighbors objectAtIndex:index];
}

- (void) addNeighbor:(AStarNode *) neighbor
{
	[_neighbors addObject:neighbor];
}

- (void) removeNeighbor:(AStarNode *) neighbor
{
	[_neighbors removeObject:neighbor];
}

- (void) removeNeighbors:(NSArray *) neighbors
{
	for(NSInteger i = 0; i < [neighbors count]; i++)
	{
		AStarNode *neighbor = [neighbors objectAtIndex:i];
		[self removeNeighbor:neighbor];
	}
}

- (void) removeAllNeighbors
{
	[_neighbors removeAllObjects];
}

- (BOOL) isNeighborExists:(AStarNode *) neighbor
{
	return [_neighbors containsObject:neighbor];
}

-(void) dealloc {
	
	[_neighbors release];
	
	[super dealloc];	
}

@end
