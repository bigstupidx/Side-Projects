//
//  TilePathFinder.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TilePathFinder.h"


@implementation TilePathFinder

- (id) initWithTileMap:(TileMap *) tileMap
{
	[super init];
	
	_tileMap = tileMap;
	[_tileMap retain];
	
	_aStar = [[AStar alloc] init];
	
	_nodes = [[NSMutableArray alloc] init];
	
	// Create nodes.
	for(NSInteger i = 0; i < [tileMap getMapSize].height; i++)
	{
		NSMutableArray *nodesRow = [[NSMutableArray alloc] init];
		
		for(NSInteger j = 0; j < [tileMap getMapSize].width; j++)
		{
			Index index = IndexMake(j, i);
			CGPoint center = [_tileMap getTileCenter:index];
			AStarNode *node = [[[AStarNode alloc] initWithPosition:center] autorelease];
			[_aStar addNode:node];
			[nodesRow addObject:node];
		}
		
		[_nodes addObject:nodesRow];
	}
	
	// Create neighbor relations.
	for(NSInteger i = 0; i < [tileMap getMapSize].height; i++)
		for(NSInteger j = 0; j < [tileMap getMapSize].width; j++)
		{
			Index index = IndexMake(j, i);
			AStarNode *node = [self getNodeAtIndex:index];
			
			NSArray *neighborPositions = [self getNeighborPositions:[node getPosition]];
			
			for(NSInteger k = 0; k < [neighborPositions count]; k++)
			{
				CGPoint neighborPosition = [(NSValue *) [neighborPositions objectAtIndex:k] CGPointValue];
				Index neighborIndex = [[self getTileMap] getTileIndexAtPosition:neighborPosition];
				AStarNode *neighborNode = [self getNodeAtIndex:neighborIndex];
				[node addNeighbor:neighborNode];
			}
		}
	
	return self;
}

- (TileMap *) getTileMap
{
	return _tileMap;
}

- (AStarNode *) getNodeAtIndex:(Index) index
{
	if(index.row == NSNotFound || index.column == NSNotFound)
		return nil;
	
	return [(NSArray *) [_nodes objectAtIndex:index.row] objectAtIndex:index.column];
}

- (NSArray *) getNeighborPositions:(CGPoint) position
{
	Index index = [[self getTileMap] getTileIndexAtPosition:position];
	
	NSMutableArray *neighborPositions = [[[NSMutableArray alloc] init] autorelease];
	
	// Top.
	if(index.row - 1 >= 0) 
	{
		Index neighborIndex = IndexMake(index.column, index.row - 1);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Bottom.
	if(index.row + 1 < [[self getTileMap] getMapSize].height)
	{
		Index neighborIndex = IndexMake(index.column, index.row + 1);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Left.
	if(index.column - 1 >= 0)
	{
		Index neighborIndex = IndexMake(index.column - 1, index.row);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Right.
	if(index.column + 1 < [[self getTileMap] getMapSize].width)
	{
		Index neighborIndex = IndexMake(index.column + 1, index.row);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Top-left.
	if(index.row - 1 >= 0  && index.column - 1 >= 0)
	{
		Index neighborIndex = IndexMake(index.column - 1, index.row - 1);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Top-right.
	if(index.row - 1 >= 0 && index.column + 1 < [[self getTileMap] getMapSize].width)
	{
		Index neighborIndex = IndexMake(index.column + 1, index.row - 1);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Bottom-left.
	if(index.row + 1 < [[self getTileMap] getMapSize].height && index.column - 1 >= 0)
	{
		Index neighborIndex = IndexMake(index.column - 1, index.row + 1);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
	
	// Bottom-right.
	if(index.row + 1 < [[self getTileMap] getMapSize].height && index.column + 1 < [[self getTileMap] getMapSize].width)
	{
		Index neighborIndex = IndexMake(index.column + 1, index.row + 1);
		CGPoint neighborPosition = [[self getTileMap] getTileCenter:neighborIndex];
		[neighborPositions addObject:[NSValue valueWithCGPoint:neighborPosition]];
	}
		
	return [neighborPositions count] == 0 ? nil : neighborPositions;
}

- (NSArray *) getShortestPath:(CGPoint) source :(CGPoint) destination
{
	if(![[self getTileMap] isTileAccessibleAtPosition:source])
		return nil;
	else if(![[self getTileMap] isTileAccessibleAtPosition:destination])
		return nil;
	
	// Determine access of tiles.
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
		{
			Index index = IndexMake(j, i);
			
			if([[self getTileMap] isTileAccessibleAtIndex:index])
				[[self getNodeAtIndex:index] setAccessible:YES];
			else 
				[[self getNodeAtIndex:index] setAccessible:NO];
		}
	
	// Get path as nodes.
	AStarNode *sourceNode = [self getNodeAtIndex:[[self getTileMap] getTileIndexAtPosition:source]];
	AStarNode *destinationNode = [self getNodeAtIndex:[[self getTileMap] getTileIndexAtPosition:destination]];
	NSArray *pathAsNodes = [_aStar getShortestPath:sourceNode :destinationNode];
	if(pathAsNodes == nil)
		return nil;
	
	// Convert path to points.
	NSMutableArray *pathAsPoints = [[[NSMutableArray alloc] init] autorelease];	
	for(NSInteger i = 0; i < [pathAsNodes count]; i++)
	{
		AStarNode *node = [pathAsNodes objectAtIndex:i];
		NSValue *value = [NSValue valueWithCGPoint:[node getPosition]];
		[pathAsPoints addObject:value];
	}
	
	return pathAsPoints;
}

- (void) dealloc 
{
	[_aStar release];
	[_nodes removeAllObjects];
	[_nodes release];
	[_tileMap release];

	[super dealloc];
}

@end
