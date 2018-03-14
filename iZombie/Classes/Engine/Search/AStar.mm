//
//  AStar.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AStar.h"


@implementation AStar

- (id) init
{
	[super init];
	
	_nodes = [[NSMutableArray alloc] init];
	
	return self;
}

- (NSArray *) getNodes
{
	return _nodes;
}

- (NSInteger) getCountNodes
{
	return [_nodes count];
}

- (AStarNode *) getNode:(NSInteger) index
{
	return (AStarNode *) [_nodes objectAtIndex:index];
}

- (void) addNode:(AStarNode *) node
{
	[_nodes addObject:node];
}

- (void) addNodes:(NSArray *) nodes
{
	for(NSInteger i = 0; i < [nodes count]; i++)
	{
		AStarNode *node = [nodes objectAtIndex:i];
		[self addNode:node];
	}
}

- (void) removeNode:(AStarNode *) node
{
	[_nodes removeObject:node];
}

- (void) removeNodes:(NSArray *) nodes
{
	for(NSInteger i = 0; i < [nodes count]; i++)
	{
		AStarNode *node = [nodes objectAtIndex:i];
		[self removeNode:node];
	}
}

- (void) removeAllNodes
{
	[_nodes removeAllObjects];
}

- (BOOL) isNodeExists:(AStarNode *) node
{
	return [_nodes containsObject:node];
}

- (AStarNode *) getNodeWithMinimumDistance:(NSArray *) nodes
{
	AStarNode *nodeWithMinimumDistance = nil;
	
	if(nodes != nil && [nodes count] != 0)
	{
		nodeWithMinimumDistance = [nodes objectAtIndex:0];
	
		for(NSInteger i = 1; i < [nodes count]; i++)
		{
			AStarNode *node = [nodes objectAtIndex:i];
			
			if([node getDistance] < [nodeWithMinimumDistance getDistance])
				nodeWithMinimumDistance = node;
		}
	}
	
	return nodeWithMinimumDistance;
}

- (CGFloat) getDistanceBetweenNodes:(AStarNode *) source :(AStarNode *) destination
{
	return [source getDistance] + [[MathUtility getInstance] getDistanceBetweenPoints:[source getPosition] :[destination getPosition]];
}

- (NSArray *) getShortestPath:(AStarNode *) source :(AStarNode *) destination
{
	if(source == nil)
		return nil;
	else if(destination == nil)
		return nil;
	
	NSMutableArray *path = nil;
	
	NSMutableArray *openNodes = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *closeNodes = [[[NSMutableArray alloc] init] autorelease];
	
	[source setDistance:0];
	[openNodes addObject:source];
	
	while([openNodes count] != 0)
	{
		AStarNode *nodeWithMinimumDistance = [self getNodeWithMinimumDistance:openNodes];
		
		if([nodeWithMinimumDistance isEqual:destination])
		{
			path = [[[NSMutableArray alloc] init] autorelease];
			
			while(nodeWithMinimumDistance != nil)
			{
				[path insertObject:nodeWithMinimumDistance atIndex:0];				
				nodeWithMinimumDistance = [nodeWithMinimumDistance getParent];
			}
						
			break;
		}	
		
		[openNodes removeObject:nodeWithMinimumDistance];
		[closeNodes addObject:nodeWithMinimumDistance];
		
		NSArray *neighborNodes = [nodeWithMinimumDistance getNeighbors];
		
		for(NSInteger i = 0; i < [neighborNodes count]; i++)
		{
			AStarNode *neighborNode = [neighborNodes objectAtIndex:i];
			if(![neighborNode isAccessible])
				continue;
			
			CGFloat distance = [self getDistanceBetweenNodes:nodeWithMinimumDistance :neighborNode];
			
			if([closeNodes containsObject:neighborNode])
				continue;
			else if(![openNodes containsObject:neighborNode])
			{
				[neighborNode setDistance:distance];
				[neighborNode setParent:nodeWithMinimumDistance];
				[openNodes addObject:neighborNode];
			}
			else if(distance < [neighborNode getDistance])
			{
				[neighborNode setDistance:distance];
				[neighborNode setParent:nodeWithMinimumDistance];
			}			
		}
	}
	
	for(NSInteger i = 0; i < [self getCountNodes]; i++)
	{
		AStarNode *node = [self getNode:i];
		[node setParent:nil];
		[node setDistance:0];
	}
	
	[openNodes removeAllObjects];
	[closeNodes removeAllObjects];
	
	return path;
}

-(void) dealloc {
	
	[super dealloc];	
}

@end
